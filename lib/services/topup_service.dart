import 'package:airplane/models/topup_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopupService {
  final CollectionReference _topupRef =
      FirebaseFirestore.instance.collection('topups');
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> createTopup({
    required int nominal,
    required String user_id,
    required int balanceNow,
  }) async {
    try {
      _topupRef.add({
        "user_id": user_id,
        "nominal": nominal,
        "created_at": DateTime.now(),
      });
      _userReference.doc(user_id).update({
        'balance': nominal + balanceNow,
      });
    } catch (e) {
      throw e;
    }
  }

  // Future<List<TopupModel>> getTopup(user_id) async {
  //   try {} catch (e) {}
  // }
}
