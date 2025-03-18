import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../location/bloc/location_bloc.dart';
import '../repository/data rmodel/service_model.dart';
import '../repository/salonservices helper/fetch_services_helper.dart';

part 'shops_events.dart';
part 'shops_state.dart';

class ShopsBloc extends Bloc<ShopsEvent, ShopsState> {
  List<ShopModel>? serviceman;
  ShopModel? singleServiceMan;
  ShopModel? singleService;
  final LocationBloc locationBloc;

  List<ShopModel>? serviceman2 = [];
  List<ShopModel>? serviceman3 = [];
  static SalonServiceHelper salonHelper = SalonServiceHelper();
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;
  int serviceNum = 0;
  int num = 0;
  int total = 0;

  ShopsBloc(this.locationBloc) : super(ShopInitial()) {
    on<ViewShopsEvent>(fetchShops);
    on<SearchShopEvent>(searchShops);
    on<CreateShopEvent>(createShop);
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
      SearchShopEvent event, Emitter<ShopsState> emit) async {
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

  Future<void> createShop(
      CreateShopEvent event, Emitter<ShopsState> emit) async {
    try {
      emit(ShopsLoadingState());
      debugPrint("Creating shop service......");
      final shop = ShopModel(
        shopOwnerId: event.shopOwnerId,
        shopName: event.shopName,
        category: event.category,
        openingDays: event.openingDays,
        operningTimes: event.operningTimes,
        location: event.location,
        phone: event.phone,
        whatsapp: event.whatsapp,
        services: event.services,
        profileImg: event.profileImg,
        dateJoined: event.dateJoined,
        workImgs: event.workImgs,
        cordinates: event.cordinates,
        distanceToUser: event.distanceToUser,
      );
      salonHelper.createService(shop);
      emit(
          ShopCreatedSuccesState(message: 'Shop service created succesfuly!!'));
      debugPrint("Shop service created succesfuly!!");
    } catch (e) {
      emit(ShopCreateFailureState(error: e.toString()));
      debugPrint(e.toString());
    }
  }

  Future<List<ShopModel>?> fetchShops(
      ViewShopsEvent event, Emitter<ShopsState> emit) async {
    emit(ShopsLoadingState());
    try {
      final locationState = locationBloc.state;
      debugPrint("LocationBloc State: $locationState");

      if (locationState is LocationFetchedState) {
        double? userLatitude = locationState.latitude;
        double? userLongitude = locationState.longitude;
        debugPrint("✅ Location Fetched: $userLatitude, $userLongitude");

        serviceman =
            await salonHelper.fetchAllSalonShops(userLatitude, userLongitude);
        num = serviceman?.length ?? 0;
        serviceman2 = serviceman;
        serviceman3 = serviceman2;
        total = num;

        debugPrint("✅ Total Nearby Shops: $num");
        emit(ShopsFetchedState(shop: serviceman));

        if (userLatitude == null || userLongitude == null) {
          debugPrint("Error: Latitude or Longitude is null!");
          emit(ShopsFetchFailureState(
              errorMessage: "User location not available."));
        }
      } else {
        debugPrint("❌ Error: User location not available.");
        emit(ShopsFetchFailureState(
            errorMessage: "User location not available."));
      }
    } on FirebaseAuthException catch (error) {
      debugPrint("❌ Firebase Error: $error");
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
    } catch (error) {
      debugPrint("❌ Error: $error");
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
    }
    return serviceman;
  }

/*
  Future<List<ShopModel>?> fetchShops(
      ViewShopsEvent event, Emitter<ShopsState> emit) async {
    emit(ShopsLoadingState());
    try {
      if (serviceman == null) {
        serviceman = await salonHelper.fetchAllSalonShops();
        num = serviceman?.length ?? 0;

        serviceman2 = serviceman;
        serviceman3 = serviceman2;
        total = num;
        emit(ShopsFetchedState(shop: serviceman));
        debugPrint("Total Services is $num");
      }
    } on FirebaseAuthException catch (error) {
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
      debugPrint(error.toString());
    } catch (error) {
      emit(ShopsFetchFailureState(errorMessage: error.toString()));
      debugPrint('Error:${error.toString()}');
    }
    return serviceman;
  }
*/
  Future<ShopModel?> fetchSingleShop(
      ViewSingleShopEvent event, Emitter<ShopsState> emit) async {
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
