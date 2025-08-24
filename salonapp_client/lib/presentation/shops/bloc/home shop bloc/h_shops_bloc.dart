import 'dart:core';
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
    on<SearchShopEvent>(onSearchShops);
  }

  void onSearchShops(SearchShopEvent event, Emitter<HomeShopsState> emit) {
    final results = searchShops(
      shops: serviceman ?? [],
      query: event.query,
      service: event.service,
      category: event.gender,
      distance: event.distance,
      priceRange: event.priceRange,
    );

    serviceman2 = results;
    emit(ShopsFetchedState(shop: results));
  }

  void onSearchChanged(String query) {
    serviceman = serviceman2!
        .where((servicemen) => servicemen.shopName!
            .trim()
            .toLowerCase()
            .contains(query.trim().toLowerCase()))
        .toList();
  }

  List<HomeShopModel> searchShops({
    required List<HomeShopModel> shops,
    String? query,
    String? service,
    String? category,
    double? distance,
    RangeValues? priceRange,
  }) {
    return shops.where((shop) {
      final matchesQuery = query == null || query.isEmpty
          ? true
          : shop.shopName!.toLowerCase().contains(query.toLowerCase());

      final matchesService = (service == null || service.isEmpty)
          ? true
          : _offersService(shop.services, service);

      final matchesCategory = category == null || category.isEmpty
          ? true
          : shop.category?.toLowerCase() == category.toLowerCase();

      return matchesQuery && matchesService && matchesCategory;
    }).toList();
  }

  bool _offersService(dynamic services, String wanted) {
    if (services == null || wanted.isEmpty) return true;

    final needle = wanted.toLowerCase().trim();

    if (services is Map) {
      if (services.containsKey(wanted)) {
        final v = services[wanted];
        if (v is bool) return v;
        // if (v is num) return v != 0;   // ✅ now works
        if (v is String) return v.toLowerCase() == 'true';
        if (v is Map) return true;
        return true;
      }
      return services.keys
          .map((k) => k.toString().toLowerCase().trim())
          .contains(needle);
    }

    if (services is List) {
      return services
          .map((e) => e.toString().toLowerCase().trim())
          .contains(needle);
    }

    if (services is String) {
      return services
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .contains(needle);
    }

    return false;
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
}
