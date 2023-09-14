import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/order/models/order_model.dart';
import 'package:delivery_app/order/models/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio, baseUrl: 'http://$ip/order');
});

@RestApi()
abstract class OrderRepository {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @POST("/")
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
