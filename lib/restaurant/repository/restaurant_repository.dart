import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi(baseUrl: 'http://127.0.0.1:3000/restaurant')
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  @Headers({"accessToken": "true"})
  Future<CursorPagination<RestaurantModel>> paginate();

  @GET('/{id}')
  @Headers({"accessToken": "true"})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
