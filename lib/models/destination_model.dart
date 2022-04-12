import 'package:equatable/equatable.dart';

class DestinationModel extends Equatable {
  final String id;
  final String name;
  final String city;
  final String imageUrl;
  final int price;
  final double rating;

  DestinationModel({
    required this.id,
    this.name = '',
    this.city = '',
    this.imageUrl = '',
    this.price = 0,
    this.rating = 0.0,
  });

  factory DestinationModel.fromJson(String id, Map<String, dynamic> json) {
    return DestinationModel(
      id: id,
      name: json['name'],
      imageUrl: json['imageUrl'],
      city: json['city'],
      price: json['price'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "city": city,
        "price": price,
        "rating": rating,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, imageUrl, city, price, rating];
}
