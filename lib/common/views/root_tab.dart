import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/order/views/order_screen.dart';
import 'package:delivery_app/product/views/product_screen.dart';
import 'package:delivery_app/restaurant/views/restaurant_screen.dart';
import 'package:delivery_app/user/views/profile_screen.dart';
import 'package:flutter/material.dart';

class RootTap extends StatefulWidget {
  const RootTap({super.key});

  @override
  State<RootTap> createState() => _RootTapState();
}

class _RootTapState extends State<RootTap> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_tabListener);
  }

  void _tabListener() {
    setState(() {
      index = _tabController.index;
    });
  }

  void _onChangeIndex(int i) => _tabController.animateTo(i);

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultLayout(
        title: "코팩 딜리버리",
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: _onChangeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined),
              label: '음식',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: '주문',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '프로필',
            ),
          ],
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            RestaurantScreen(),
            ProductScreen(),
            OrderScreen(),
            ProfileScreen()
          ],
        ),
      ),
    );
  }
}
