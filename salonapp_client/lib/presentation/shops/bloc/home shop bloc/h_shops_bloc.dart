import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication screens/bloc/auth_bloc.dart';
import '../../../authentication screens/repository/data model/user_model.dart';
import '../../repository/data rmodel/h_shop_service_model.dart';
import '../../repository/salonservices helper/fetch_services_helper.dart';
part 'h_shops_events.dart';
part 'h_shops_state.dart';

class HomeShopsBloc extends Bloc<HomeShopsEvent, HomeShopsState> {
  List<HomeShopModel>? serviceman;
  HomeShopModel? singleServiceMan;
  HomeShopModel? singleService;
  final AuthBloc authBloc;

  List<HomeShopModel>? serviceman2 = [];
  List<HomeShopModel>? serviceman3 = [];
  static SalonServiceHelper salonHelper = SalonServiceHelper();
  UserModel? user;

  int serviceNum = 0;
  int num = 0;
  int total = 0;

  HomeShopsBloc(this.authBloc) : super(HomeShopInitial()) {
    on<ViewHomeShopsEvent>(fetchShops);
    on<SearchShopEvent>(searchShops);
    on<ViewSingleShopEvent>(fetchSingleShop);
  }
  void onSearchChanged(String query) {
    serviceman = serviceman2!
        .where((servicemen) => servicemen.shopName!
            .trim()
            .toLowerCase()
            .contains(query.trim().toLowerCase()))
        .toList();
  }

  Future<void> searchShops(
      SearchShopEvent event, Emitter<HomeShopsState> emit) async {
    try {
      emit(ShopsLoadingState());
      if (event.query.isNotEmpty) {
        onSearchChanged(event.query);
        emit(ShopsFetchedState(shop: serviceman!));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<HomeShopModel>?> fetchShops(
      ViewHomeShopsEvent event, Emitter<HomeShopsState> emit) async {
    emit(ShopsLoadingState());
    try {
      final authState = authBloc.state;
      if (serviceman == null) {
        serviceman = await salonHelper.fetchHomeSalonShops();
        num = serviceman?.length ?? 0;

        serviceman2 = serviceman;
        serviceman3 = serviceman2;
        total = num;
        emit(ShopsFetchedState(shop: serviceman2));
        debugPrint("Total Services is $num");
      }
      if (authState is CurrentUserState) {
        user = authState.user;
        debugPrint("Current User Account: ${user!.fullname}");
      }
    } on FirebaseAuthException catch (error) {
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
      debugPrint(error.toString());
    } catch (error) {
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
      debugPrint('Error:${error.toString()}');
    }
    return serviceman2;
  }

  Future<HomeShopModel?> fetchSingleShop(
      ViewSingleShopEvent event, Emitter<HomeShopsState> emit) async {
    try {
      String? userId = event.id;
      //  if (userId != null) {
      emit(ShopsLoadingState());
      singleServiceMan = await salonHelper.fetchSingleHomeSalonshops(userId);

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
