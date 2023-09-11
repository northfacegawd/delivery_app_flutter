import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/utils/pagination_util.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: _controller,
      provider: ref.read(restaurantProvider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        controller: _controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (context, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator(color: PRIMARY_COLOR)
                    : const Text("더 가져올 수 있는 데이터가 없습니다."),
              ),
            );
          }
          final item = cp.data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(id: item.id),
                ),
              );
            },
            child: RestaurantCard.fromModel(model: item),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }
}
