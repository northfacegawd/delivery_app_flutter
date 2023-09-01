import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/components/product_card.dart';
import 'package:delivery_app/product/models/product_model.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:delivery_app/restaurant/models/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  Future getRestaurantDetail() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final res = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: "불타는 떡볶이",
        child: FutureBuilder(
          future: getRestaurantDetail(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PRIMARY_COLOR,
                ),
              );
            }
            final item = RestaurantDetailModel.fromJson(json: snapshot.data);
            return CustomScrollView(
              slivers: [
                renderTop(item),
                renderLabel(),
                renderProducts(item.products),
              ],
            );
          },
        ));
  }

  SliverToBoxAdapter renderTop(RestaurantDetailModel item) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: item,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderProducts(List<ProductModel> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const Padding(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: ProductCard(),
            );
          },
          childCount: 10,
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          "메뉴",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
