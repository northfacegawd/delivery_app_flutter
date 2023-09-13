import 'package:delivery_app/product/models/product_model.dart';
import 'package:delivery_app/user/models/basket_item_model.dart';
import 'package:delivery_app/user/models/patch_basket_body.dart';
import 'package:delivery_app/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketStateNotifier, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketStateNotifier(repository: repository);
});

class BasketStateNotifier extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketStateNotifier({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;
    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: 1),
      ];
    }
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool? isDelete = false,
  }) async {
    final existingProduct =
        state.firstWhereOrNull((e) => e.product.id == product.id);

    if (existingProduct == null) return;
    if (existingProduct.count == 1 || isDelete!) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }

    await patchBasket();
  }
}
