import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);
  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(restaurantRepositoryProvider),
  ),
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  getDetail({
    required String id,
  }) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면) 데이터를 가져옴
    if (state is! CursorPagination) {
      await paginate();
    }
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final res = await repository.getRestaurantDetail(id: id);
    if (pState.data.where((element) => element.id == id).isEmpty) {
      state = pState.copyWith(data: <RestaurantModel>[...pState.data, res]);
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? res : e)
            .toList(),
      );
    }
  }
}
