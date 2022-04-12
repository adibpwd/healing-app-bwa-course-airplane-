import 'package:airplane/models/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionService {
  final CollectionReference _transactionRef =
      FirebaseFirestore.instance.collection('transaction');
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> createTransaction(
    TransactionModel transaction,
    int balanceNow,
    String user_id,
  ) async {
    try {
      _transactionRef.add({
        "destination": transaction.destination.toJson(),
        "amountOfTraveler": transaction.amountOfTraveler,
        "selectedSeats": transaction.selectedSeats,
        "insurance": transaction.insurance,
        "refundable": transaction.refundable,
        "price": transaction.price,
        "vat": transaction.vat,
        "grandTotal": transaction.grandTotal,
        "user_id": user_id,
      });
      _userReference.doc(user_id).update({
        'balance': balanceNow - transaction.grandTotal,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<List<TransactionModel>> fetchTransactions(String user_id) async {
    try {
      QuerySnapshot result =
          await _transactionRef.where('user_id', isEqualTo: user_id).get();
      List<TransactionModel> transactions = result.docs.map((e) {
        return TransactionModel.fromJson(
            e.id, e.data() as Map<String, dynamic>);
      }).toList();

      return transactions;
    } catch (e) {
      throw e;
    }
  }
}
