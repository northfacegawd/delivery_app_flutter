import 'package:delivery_app/auth/provider/auth_provider.dart';
import 'package:delivery_app/auth/views/login_screen.dart';
import 'package:delivery_app/common/views/root_tab.dart';
import 'package:delivery_app/common/views/splash_screen.dart';
import 'package:delivery_app/restaurant/views/basket_screen.dart';
import 'package:delivery_app/restaurant/views/order_suceess_screen.dart';
import 'package:delivery_app/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum RouteName {
  splash,
  login,
  home,
  restaurantDetail,
  basket,
  orderSuccess,
}

final routeProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.home.name,
        builder: (context, state) => const RootTap(),
        routes: [
          GoRoute(
            path: 'restaurant/:rid',
            name: RouteName.restaurantDetail.name,
            builder: (context, state) {
              return RestaurantDetailScreen(id: state.pathParameters['rid']!);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/basket',
        name: RouteName.basket.name,
        builder: (context, state) => const BasketScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: RouteName.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteName.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/order_success',
        name: RouteName.orderSuccess.name,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
    ],
    refreshListenable: provider,
    redirect: (context, state) {
      return provider.redirectLogic(state);
    },
  );
});
