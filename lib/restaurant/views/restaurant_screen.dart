import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RestaurantCard(
            image: Image.asset(
              'assets/img/food/ddeok_bok_gi.jpg',
              fit: BoxFit.cover,
            ),
            name: "불타는 떡볶이",
            tags: const ["떡볶이", "치즈", "매운맛"],
            ratingCount: 5000,
            deliveryTime: 30,
            deliveryFee: 2500,
            rating: 5.0,
          ),
        ),
      ),
    );
  }
}
