import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class RootTap extends StatelessWidget {
  const RootTap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DefaultLayout(
        child: Center(
          child: Text("Root Tap"),
        ),
      ),
    );
  }
}
