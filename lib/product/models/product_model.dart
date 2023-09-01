import 'package:delivery_app/auth/constants/data.dart';

class ProductModel {
  final String id, name, imgUrl, detail;
  final int price;

  ProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory ProductModel.fromJson({required Map<String, dynamic> json}) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imgUrl: 'http://$ip${json['imgUrl']}',
      detail: json['detail'],
      price: json['price'],
    );
  }
}
