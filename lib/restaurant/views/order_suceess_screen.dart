import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/common/provider/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.thumb_up_alt_outlined,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(height: 32),
            const Text(
              "결제가 완료되었습니다.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
              onPressed: () => context.goNamed(RouteName.home.name),
              child: const Text("홈으로"),
            )
          ],
        ),
      ),
    );
  }
}
