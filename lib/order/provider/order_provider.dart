import 'package:delivery_app/order/models/order_model.dart';
import 'package:delivery_app/order/models/post_order_body.dart';
import 'package:delivery_app/order/repository/order_repository.dart';
import 'package:delivery_app/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({required this.ref, required this.repository}) : super([]);

  Future<bool> postOrder() async {
    try {
      final id = const Uuid().v4();
      final state = ref.read(basketProvider);

      await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map((e) =>
                  PostOrderBodyProduct(productId: e.product.id, count: e.count))
              .toList(),
          totalPrice: state.fold<int>(
              0,
              (prev, current) =>
                  prev + (current.count * current.product.price)),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e, stack) {
      print(e);
      print(stack);
      return false;
    }
  }
}
