import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/rating/models/rating_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, id) {
  final repository = ref.watch(restaurantRatingRepositoryProvider(id));

  return RestaurantRatingStateNotifier(repository: repository);
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  @override
  RestaurantRatingStateNotifier({required super.repository});
}
