import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class RootTap extends StatefulWidget {
  const RootTap({super.key});

  @override
  State<RootTap> createState() => _RootTapState();
}

class _RootTapState extends State<RootTap> {
  int index = 0;

  void _onChangeIndex(int i) => setState(() => index = i);

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
        child: const Center(
          child: Text("Root Tap"),
        ),
      ),
    );
  }
}
