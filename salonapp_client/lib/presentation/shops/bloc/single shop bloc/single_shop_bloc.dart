import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/presentation/shops/repository/data%20rmodel/service_model.dart';
import '../../repository/salonservices helper/fetch_services_helper.dart';

part 'single_shop_state.dart';
part 'single_shop_event.dart';

class SingleShopBloc extends Bloc<SingleShopsEvent, SingleShopsState> {
  ShopModel? singleServiceMan;
  ShopModel? singleService;
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;

  static SalonServiceHelper salonHelper = SalonServiceHelper();
  int serviceNum = 0;
  int total = 0;

  SingleShopBloc() : super(ShopInitial()) {
    on<ViewSingleShopEvent>(fetchSingleShop);
  }

  Future<ShopModel?> fetchSingleShop(
      ViewSingleShopEvent event, Emitter<SingleShopsState> emit) async {
    try {
      String? userId = event.id;
      emit(ShopsLoadingState());
      singleServiceMan = await salonHelper.fetchSinglesalonshops(userId);

      if (singleServiceMan != null) {
        singleService = singleServiceMan;
        emit(SingleShopsFetchedState(shop: singleService));
        debugPrint("Single Shop: $singleService");
        total = serviceNum;
      } else {
        emit(ShopsFetchFailureState(errorMessage: "Shop not found"));
        debugPrint("Single Shop not found");
      }
      //}
      print(total);
    } on FirebaseAuthException catch (error) {
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
      debugPrint(error.toString());
    } catch (error) {
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
      debugPrint('Error:${error.toString()}');
    }

    return singleService;
  }
}
