import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadProduct {

  UploadProduct(
      this.id,
      this.name,
      this.image,
      this.price,
      this.desc,
      this.stock,
      this.from,
      );

  String
  id,
      name,
      image,
      price,
      desc,
      stock,
      from;

  UploadProduct.fromJson(Map<dynamic,dynamic> json)
    :
        id = json['id'] as String,
    name = json['name'] as String,
    image= json['image'] as String,
        price = json['price'] as String,
        desc = json['desc']as String,
        stock = json['stock']as String,
        from = json['from']as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{

        'id': id,
        'name': name,
        'image': image,
        'price': price,
        'desc': desc,
        'stock': stock,
        'from': from,
      };
}