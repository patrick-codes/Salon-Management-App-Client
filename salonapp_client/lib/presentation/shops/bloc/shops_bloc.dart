import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data repository/image uploader/cloudinary_uploader.dart';
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
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;

  List<ShopModel>? serviceman2 = [];
  List<ShopModel>? serviceman3 = [];
  static SalonServiceHelper salonHelper = SalonServiceHelper();
  int serviceNum = 0;
  int num = 0;
  int total = 0;

  ShopsBloc(this.locationBloc) : super(ShopInitial()) {
    on<ViewShopsEvent>(fetchShops);
    on<SearchShopEvent>(searchShops);
    on<PickProfileImageEvent>(onPickImage);
    on<PickShopImageEvent>(onPickWorkImage);
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

  Future<void> onPickImage(
      PickProfileImageEvent event, Emitter<ShopsState> emit) async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        final url = await CloudinaryHelper2.uploadImage(File(picked.path));
        if (url != null) {
          emit(ImagePickedState(pickedFile: file, imageUrl: url));
        }
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      emit(ShopCreateFailureState(error: e.toString()));
    }
  }

  Future<void> onPickWorkImage(
      PickShopImageEvent event, Emitter<ShopsState> emit) async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((e) => File(e.path)).toList();
        emit(LocalImagesPickedState(files)); // just send picked files
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      emit(ShopCreateFailureState(error: e.toString()));
    }
  }

  Future<void> createShop(
    CreateShopEvent event,
    Emitter<ShopsState> emit,
  ) async {
    try {
      emit(ShopsLoadingState());

      String? profileImgUrl;
      List<String> workImgUrls = [];

      //  Upload profile image if picked
      if (event.profileImgFile != null) {
        profileImgUrl =
            await CloudinaryHelper2.uploadImage(event.profileImgFile!);
      }

      if (event.workImgFiles != null && event.workImgFiles!.isNotEmpty) {
        for (var file in event.workImgFiles!) {
          final url = await CloudinaryHelper.uploadImage(file);
          if (url != null) workImgUrls.add(url);
        }
      }

      //  Get coordinates
      final position = await Geolocator.getCurrentPosition();
      event.cordinates = [position.latitude, position.longitude];

      //  Save shop to Firestore with uploaded URLs
      final shopData = ShopModel(
        shopOwnerId: firebaseUser,
        shopName: event.shopName,
        category: event.category,
        cordinates: event.cordinates,
        openingDays: event.openingDays,
        operningTimes: event.operningTimes,
        location: event.location,
        phone: event.phone,
        whatsapp: event.whatsapp,
        services: event.services,
        profileImg: profileImgUrl ?? "", //  uploaded profile image URL
        dateJoined: event.dateJoined,
        workImgs: workImgUrls, //  use uploaded work image URLs
        distanceToUser: event.distanceToUser,
        isOpen: event.isOpen,
      );

      await salonHelper.createService(shopData);

      debugPrint('✅ Shop Created Successfully');
      emit(ShopCreatedSuccesState(message: 'Shop Created Successfully'));
    } catch (e, st) {
      debugPrint('❌ Failed to create shop: $e');
      debugPrintStack(stackTrace: st);
      emit(ShopCreateFailureState(error: "Failed to create shop: $e"));
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
