import 'package:delivery_app/common/components/pagination_list_view.dart';
import 'package:delivery_app/product/components/product_card.dart';
import 'package:delivery_app/product/models/product_model.dart';
import 'package:delivery_app/product/provider/product_provider.dart';
import 'package:delivery_app/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailScreen(id: model.restaurant.id),
                ),
              );
            },
            child: ProductCard.fromProductModel(model: model));
      },
    );
  }
}
