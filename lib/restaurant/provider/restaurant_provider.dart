import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/models/pagination_params.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(restaurantRepositoryProvider),
  ),
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  void paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    bool fetchMore = false,
    // 강제로 리로딩
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 케이스 (5가지 State)
      // 1) CursorPagination - 정상적으로 데이터를 받아온 상태
      // 2) CursorPaginationLoading - 데이터를 가져오는 중인 상태
      // 3) CursorPaginationError - 데이터를 받아오는 중 에러가 발생한 상태
      // 4) CursorPaginationRefetch - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 가져오는중

      // 바로 반환하는 상황
      // 1) hasMore == false (기존 상태에서 이미 다음 데이터가 없다는 걸 알고있는 경우)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchMore = state is CursorPaginationFetchingMore;

      // 2) 로딩중 - fetchMore == true
      //    fetchMore가 아닐 때 - 새로고침의 의도
      if (fetchMore && (isLoading || isRefetching || isFetchMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );
        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면 기존 데이터를 보존한채로 fetch를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final res = await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;
        // 기존 데이터에 새로운 데이터 추가
        state = res.copyWith(
          data: [
            ...pState.data,
            ...res.data,
          ],
        );
      } else {
        state = res;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 받아올 수 없습니다.');
    }
  }
}
