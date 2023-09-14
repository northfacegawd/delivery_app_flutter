import 'package:delivery_app/common/components/pagination_list_view.dart';
import 'package:delivery_app/order/components/order_card.dart';
import 'package:delivery_app/order/models/order_model.dart';
import 'package:delivery_app/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(context, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
