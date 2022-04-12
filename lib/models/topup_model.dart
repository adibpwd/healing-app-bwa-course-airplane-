import 'package:airplane/models/destination_model.dart';
import 'package:equatable/equatable.dart';

class TopupModel extends Equatable {
  final int nominal;
  final DateTime created_at;
  final String id;
  TopupModel({
    required this.nominal,
    this.id = '',
    required this.created_at,
  });

  factory TopupModel.fromJson(String id, Map<String, dynamic> json) {
    return TopupModel(
      nominal: json['nominal'],
      id: id,
      created_at: json['created_at'].toDate(),
    );
  }

  @override
  List<Object?> get props => [id, nominal, created_at];
}
