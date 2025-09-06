import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/image uploader/image_uploader.dart';
import '../../owner location/bloc/owner_location_bloc.dart';
import '../repository/data rmodel/service_model.dart';
import '../repository/salonservices helper/owner_fetch_services_helper.dart';

part 'owner_shops_events.dart';
part 'owner_shops_state.dart';

class OwnerShopsBloc extends Bloc<OwnerShopsEvent, OwnerShopsState> {
  List<OwnerShopModel>? serviceman;
  OwnerShopModel? singleServiceMan;
  OwnerShopModel? singleService;
  final OwnerLocationBloc locationBloc;
  final firebaseUser = FirebaseAuth.instance.currentUser!.uid;

  List<OwnerShopModel>? serviceman2 = [];
  List<OwnerShopModel>? serviceman3 = [];
  static OwnerSalonServiceHelper salonHelper = OwnerSalonServiceHelper();
  int serviceNum = 0;
  int num = 0;
  int total = 0;

  final OwnerSalonServiceHelper shopHelper = OwnerSalonServiceHelper();
  OwnerShopsBloc(
    this.locationBloc,
  ) : super(OwnerShopInitial()) {
    on<ViewOwnerShopsEvent>(fetchShops);
    on<OwnerSearchShopEvent>(searchShops);
    on<OwnerPickProfileImageEvent>(onPickImage);
    on<OwnerPickShopImageEvent>(onPickWorkImage);
    on<OwnerCreateShopEvent>(createShop);
    on<FetchOwnerShopEvent>(_onFetchOwnerShopEvent);
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
      OwnerSearchShopEvent event, Emitter<OwnerShopsState> emit) async {
    try {
      emit(OwnerShopsLoadingState());
      if (event.query.isNotEmpty) {
        onSearchChanged(event.query);
        emit(OwnerShopsFetchedState(shop: serviceman!));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> onPickImage(
      OwnerPickProfileImageEvent event, Emitter<OwnerShopsState> emit) async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      emit(OwnerProfileImageLoadingState());
      if (picked != null) {
        final file = File(picked.path);
        final url = await CloudinaryHelper2.uploadImage(File(picked.path));
        if (url != null) {
          emit(OwnerImagePickedState(pickedFile: file, imageUrl: url));
        }
      }
    } catch (e) {
      debugPrint('${e.toString()}');
      emit(OwnerShopCreateFailureState(error: e.toString()));
    }
  }

  Future<void> onPickWorkImage(
      OwnerPickShopImageEvent event, Emitter<OwnerShopsState> emit) async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((e) => File(e.path)).toList();
        emit(OwnerLocalImagesPickedState(files)); // just send picked files
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
      emit(OwnerShopCreateFailureState(error: e.toString()));
    }
  }

  Future<void> createShop(
    OwnerCreateShopEvent event,
    Emitter<OwnerShopsState> emit,
  ) async {
    try {
      emit(OwnerShopsLoadingState());

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
      final shopData = OwnerShopModel(
        shopOwnerId: firebaseUser,
        shopName: event.shopName,
        category: event.category,
        cordinates: event.cordinates,
        openingDays: event.openingDays,
        operningTimes: event.operningTimes,
        location: event.location,
        phone: event.phone,
        whatsapp: event.whatsapp,
        ownerservices: event.services,
        profileImg: profileImgUrl ?? "", //  uploaded profile image URL
        dateJoined: event.dateJoined,
        workImgs: workImgUrls, //  use uploaded work image URLs
        distanceToUser: event.distanceToUser,
        isOpen: event.isOpen,
      );

      await salonHelper.createService(shopData);

      debugPrint('Shop Created Successfully');
      emit(OwnerShopCreatedSuccesState(message: 'Shop Created Successfully'));
    } catch (e, st) {
      debugPrint('Failed to create shop: $e');
      debugPrintStack(stackTrace: st);
      emit(OwnerShopCreateFailureState(error: "Failed to create shop: $e"));
    }
  }

  Future<List<OwnerShopModel>?> fetchShops(
      ViewOwnerShopsEvent event, Emitter<OwnerShopsState> emit) async {
    emit(OwnerShopsLoadingState());
    try {
      final locationState = locationBloc.state;
      debugPrint("LocationBloc State: $locationState");

      if (locationState is OwnerLocationFetchedState) {
        double? userLatitude = locationState.latitude;
        double? userLongitude = locationState.longitude;
        debugPrint("Location Fetched: $userLatitude, $userLongitude");

        serviceman =
            await salonHelper.fetchAllSalonShops(userLatitude, userLongitude);
        num = serviceman?.length ?? 0;
        serviceman2 = serviceman;
        serviceman3 = serviceman2;
        total = num;

        debugPrint("Total Nearby Shops: $num");
        emit(OwnerShopsFetchedState(shop: serviceman));

        if (userLatitude == null || userLongitude == null) {
          debugPrint("Error: Latitude or Longitude is null!");
          emit(OwnerShopsFetchFailureState(
              errorMessage: "User location not available."));
        }
      } else {
        debugPrint("Error: User location not available.");
        emit(OwnerShopsFetchFailureState(
            errorMessage: "User location not available."));
      }
    } on FirebaseAuthException catch (error) {
      debugPrint("Firebase Error: $error");
      emit(OwnerShopsFetchFailureState(errorMessage: error.toString()));
    } catch (error) {
      debugPrint("Error: $error");
      emit(OwnerShopsFetchFailureState(errorMessage: error.toString()));
    }
    return serviceman;
  }

  Future<void> _onFetchOwnerShopEvent(
      FetchOwnerShopEvent event, Emitter<OwnerShopsState> emit) async {
    emit(OwnerShopLoading());
    try {
      final shop = await shopHelper.fetchOwnerSalonShop(event.ownerId);
      if (shop != null) {
        emit(OwnerShopLoaded(shop));
      } else {
        emit(OwnerShopFailure("No salon shop found for this owner."));
      }
    } catch (e) {
      emit(OwnerShopFailure("Failed to fetch salon shop: $e"));
    }
  }
}
