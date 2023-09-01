import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/components/product_card.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "불타는 떡볶이",
      child: Column(
        children: [
          RestaurantCard(
            isDetail: true,
            image: Image.asset('assets/img/food/ddeok_bok_gi.jpg'),
            name: '불타는 떡볶이',
            tags: const ['떡볶이', '맛있음', '치즈'],
            ratingsCount: 100,
            deliveryTime: 30,
            deliveryFee: 3000,
            ratings: 4.76,
            detail: '뽀글뽀글 뽀글뽀글 맛있는 라면',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProductCard(),
          )
        ],
      ),
    );
  }
}
