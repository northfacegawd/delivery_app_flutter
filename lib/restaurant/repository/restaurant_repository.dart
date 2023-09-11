import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/models/pagination_params.dart';
import 'package:delivery_app/common/repository/base_pagination_repository.dart';
import 'package:delivery_app/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio);
  return repository;
});

@RestApi(baseUrl: 'http://127.0.0.1:3000/restaurant')
abstract class RestaurantRepository
    implements IBasePaginationRepository<RestaurantModel> {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @override
  @GET('/')
  @Headers({"accessToken": "true"})
  paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({"accessToken": "true"})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
