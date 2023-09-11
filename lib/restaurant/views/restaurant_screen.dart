import 'package:delivery_app/common/components/pagination_list_view.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantDetailScreen(id: model.id),
              ),
            );
          },
          child: RestaurantCard.fromModel(model: model),
        );
      },
    );
  }
}
