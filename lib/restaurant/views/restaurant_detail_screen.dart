import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/go_router.dart';
import 'package:delivery_app/common/utils/pagination_util.dart';
import 'package:delivery_app/product/components/product_card.dart';
import 'package:delivery_app/product/models/product_model.dart';
import 'package:delivery_app/rating/components/rating_card.dart';
import 'package:delivery_app/rating/models/rating_model.dart';
import 'package:delivery_app/restaurant/components/restaurant_card.dart';
import 'package:delivery_app/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:delivery_app/restaurant/models/restaurant_product_model.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/provider/restaurant_rating_provider.dart';
import 'package:delivery_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';
import 'package:badges/badges.dart' as badges;

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);
    print(basket.length);

    if (state == null) {
      return const DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(
            color: PRIMARY_COLOR,
          ),
        ),
      );
    }

    return DefaultLayout(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteName.basket.name),
        backgroundColor: PRIMARY_COLOR,
        child: badges.Badge(
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket
                .fold<int>(0, (prev, current) => prev + current.count)
                .toString(),
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10,
            ),
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
          ),
        ),
      ),
      title: state.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(
              restaurant: state,
              products: state.products,
              context: context,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(
              models: ratingsState.data,
            ),
        ],
      ),
    );
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: models.length,
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RatingCard.fromModel(
              model: models[index],
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate(List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SkeletonParagraph(
              style: const SkeletonParagraphStyle(
                lines: 4,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        )),
      ),
    );
  }

  SliverToBoxAdapter renderTop(RestaurantModel item) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: item,
        isDetail: true,
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

  SliverPadding renderProducts({
    required RestaurantModel restaurant,
    required List<RestaurantProductModel> products,
    required BuildContext context,
  }) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InkWell(
                onTap: () {
                  ref.read(basketProvider.notifier).addToBasket(
                        product: ProductModel(
                          id: model.id,
                          name: model.name,
                          detail: model.detail,
                          imgUrl: model.imgUrl,
                          price: model.price,
                          restaurant: restaurant,
                        ),
                      );
                },
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
