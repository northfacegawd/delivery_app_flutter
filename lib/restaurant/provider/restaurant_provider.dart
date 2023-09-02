import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
  (ref) => RestaurantStateNotifier(
    repository: ref.watch(restaurantRepositoryProvider),
  ),
);

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    paginate();
  }

  paginate() async {
    final res = await repository.paginate();
    state = res.data;
  }
}
