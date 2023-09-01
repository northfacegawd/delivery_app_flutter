import 'package:delivery_app/common/constants/colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 내부에 있는 위젯들이 최대 높이의 위젯만큼 높이를 차지함
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/img/food/ddeok_bok_gi.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "떡볶이",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "전통 떡볶이의 정석\n맛있습니다전통 떡볶이의 정석\n맛있습니다전통 떡볶이의 정석\n맛있습니다전통 떡볶이의 정석\n맛있습니다전통 떡볶이의 정석\n맛있습니다",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
                Text(
                  '₩10,000',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
