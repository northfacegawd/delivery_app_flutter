import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> paginateRestaurant() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    var res = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    return res.data['data'];
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
              print(snapshot.data);
              if (!snapshot.hasData) {
                return Container();
              }
              final restaurants = snapshot.data!;
              return ListView.separated(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final item = restaurants[index];
                  return RestaurantCard(
                    image: Image.network(
                      'http://$ip${item['thumbUrl']}',
                      fit: BoxFit.cover,
                    ),
                    name: item['name'],
                    tags: List<String>.from(item['tags']),
                    ratingsCount: item['ratingsCount'],
                    deliveryTime: item['deliveryTime'],
                    deliveryFee: item['deliveryFee'],
                    ratings: item['ratings'],
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
