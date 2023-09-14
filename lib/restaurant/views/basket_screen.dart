import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/common/provider/go_router.dart';
import 'package:delivery_app/order/provider/order_provider.dart';
import 'package:delivery_app/product/components/product_card.dart';
import 'package:delivery_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const DefaultLayout(
        title: "장바구니",
        child: Center(
          child: Text(
            "장바구니가 비어있습니다",
          ),
        ),
      );
    }

    final basketPrice = basket.fold(
      0,
      (prev, current) => prev + (current.count * current.product.price),
    );
    final deliveryFee = basket[0].product.restaurant.deliveryFee;

    return DefaultLayout(
      title: "장바구니",
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: basket.length,
                  itemBuilder: (context, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 32),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "장바구니 금액",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      Text(basketPrice.toString()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "배달비 금액",
                        style: TextStyle(
                          color: BODY_TEXT_COLOR,
                        ),
                      ),
                      if (basket.isNotEmpty)
                        Text(
                          deliveryFee.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "총액",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        (basketPrice + deliveryFee).toString(),
                        style: const TextStyle(
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      onPressed: () async {
                        final ordered =
                            await ref.read(orderProvider.notifier).postOrder();
                        if (ordered) {
                          context.goNamed(RouteName.orderSuccess.name);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red.shade400,
                              content: const Text(
                                "결제 실패!",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("결제하기"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
