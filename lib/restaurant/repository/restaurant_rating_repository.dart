import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/models/pagination_params.dart';
import 'package:delivery_app/common/repository/base_pagination_repository.dart';
import 'package:delivery_app/rating/models/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);
  return RestaurantRatingRepository(
    dio,
    baseUrl: 'http://$ip/restaurant/$id/rating',
  );
});

@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @override
  @GET('/')
  @Headers({"accessToken": "true"})
  paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
