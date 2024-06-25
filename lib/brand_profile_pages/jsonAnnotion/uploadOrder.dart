import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class UploadProduct {

  UploadProduct(
      this.id,
      this.total,
      this.from,
      this.to,
      this.products,
      // this.desc,
      // this.stock,
      // this.from,
      );

  String
  id,
  total,
      from,
      to;
      List products;
      // desc,
      // stock,
      // from;

  UploadProduct.fromJson(Map<dynamic,dynamic> json)
    :
        id = json['id'] as String,
        total = json['total'] as String,
        from = json['from'] as String,
        to= json['to'] as String,
        products = json['products'] as List;
        // desc = json['desc']as String,
        // stock = json['stock']as String,
        // from = json['from']as String;

  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{

        'id': id,
        'total': total,
        'from': from,
        'to': to,
        'products': products,
        // 'desc': desc,
        // 'stock': stock,
        // 'from': from,
      };
}