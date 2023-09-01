import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:delivery_app/restaurant/views/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();
    dio.interceptors.add(CustomInterceptor(storage: storage));
    return (await RestaurantRepository(dio).paginate()).data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: paginateRestaurant(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: PRIMARY_COLOR,
                  ),
                );
              }
              final restaurants = snapshot.data!;
              return ListView.separated(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final item = restaurants[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantDetailScreen(id: item.id),
                        ),
                      );
                    },
                    child: RestaurantCard.fromModel(model: item),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
              );
            },
          ),
        ),
      ),
    );
  }
}
