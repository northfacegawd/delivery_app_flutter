import 'package:delivery_app/auth/constants/data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_product_model.g.dart';

@JsonSerializable()
class RestaurantProductModel {
  static pathToUrl(String value) => 'http://$ip$value';

  final String id, name, detail;
  @JsonKey(fromJson: pathToUrl)
  final String imgUrl;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantProductModelToJson(this);
}
