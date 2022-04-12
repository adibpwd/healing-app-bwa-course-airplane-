import 'package:airplane/cubit/auth_cubit.dart';
import 'package:airplane/models/topup_model.dart';
import 'package:airplane/services/topup_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'topup_state.dart';

class TopupCubit extends Cubit<TopupState> {
  TopupCubit() : super(TopupInitial());

  final CollectionReference _topupRef =
      FirebaseFirestore.instance.collection('topups');

  Future topup({
    required int nominal,
    required String user_id,
    required int balanceNow,
  }) async {
    try {
      emit(TopupLoading());
      await TopupService().createTopup(
          nominal: nominal, user_id: user_id, balanceNow: balanceNow);
      // await TopupService().
      List<TopupModel> topups = await fetchTopups(user_id);
      emit(TopupSuccess(topups));
    } catch (e) {}
  }

  Future<List<TopupModel>> fetchTopups(String user_id) async {
    try {
      emit(TopupLoading());
      QuerySnapshot result =
          await _topupRef.where('user_id', isEqualTo: user_id).get();
      List<TopupModel> topups = result.docs.map((e) {
        return TopupModel.fromJson(e.id, e.data() as Map<String, dynamic>);
      }).toList();
      emit(TopupSuccess(topups));
      return topups;
    } catch (e) {
      throw e;
    }
  }
}
