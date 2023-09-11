import 'package:delivery_app/common/models/model_with_id.dart';
import 'package:delivery_app/common/utils/data_util.dart';
import 'package:delivery_app/restaurant/models/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  @override
  final String id;
  final String name;
  final String detail;
  @JsonKey(fromJson: DataUtils.pathToUrl)
  final String imgUrl;
  final int price;
  final RestaurantModel restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel.fromJson(json);
}
