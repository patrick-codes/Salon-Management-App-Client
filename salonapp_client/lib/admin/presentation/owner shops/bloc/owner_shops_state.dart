part of 'owner_shops_bloc.dart';

sealed class OwnerShopsState {}

class OwnerShopInitial extends OwnerShopsState {}

class OwnerShopsLoadingState extends OwnerShopsState {}

class OwnerShopsFetchedState extends OwnerShopsState {
  List<OwnerShopModel>? shop;

  OwnerShopsFetchedState({required this.shop});
}

class SingleOwnerShopsFetchedState extends OwnerShopsState {
  OwnerShopModel? shop;

  SingleOwnerShopsFetchedState({required this.shop});
}

class OwnerShopsFetchFailureState extends OwnerShopsState {
  final String errorMessage;

  OwnerShopsFetchFailureState({required this.errorMessage});
}

class OwnerShopCreatedSuccesState extends OwnerShopsState {
  final String message;

  OwnerShopCreatedSuccesState({
    required this.message,
  });
}

class OwnerShopCreateFailureState extends OwnerShopsState {
  final String error;

  OwnerShopCreateFailureState({required this.error});
}

class OwnerShopDeletedSuccesState extends OwnerShopsState {
  final String message;

  OwnerShopDeletedSuccesState({
    required this.message,
  });
}

class OwnerShopDeletedFailureState extends OwnerShopsState {
  final String message;

  OwnerShopDeletedFailureState({required this.message});
}

class OwnerSeachSuccesState extends OwnerShopsState {
  final String message;

  OwnerSeachSuccesState({required this.message});
}

class OwnerSeachFailureState extends OwnerShopsState {
  final String error;

  OwnerSeachFailureState({required this.error});
}

class OwnerEmptyShopState extends OwnerShopsState {
  final String message;

  OwnerEmptyShopState({required this.message});
}

class OwnerProfileImageLoadingState extends OwnerShopsState {}

class OwnerImagePickedState extends OwnerShopsState {
  final String imageUrl;
  File? pickedFile;
  OwnerImagePickedState({required this.imageUrl, this.pickedFile});
}

class OwnerWorkImagesPickedState extends OwnerShopsState {
  final List<String> imageUrls;
  OwnerWorkImagesPickedState(this.imageUrls);
}

class OwnerLocalImagesPickedState extends OwnerShopsState {
  final List<File> pickedFiles; // the files for preview

  OwnerLocalImagesPickedState(this.pickedFiles); // positional
}

class OwnerProfileImagesPickedState extends OwnerShopsState {
  final File? pickedFile; // the files for preview

  OwnerProfileImagesPickedState(this.pickedFile); // positional
}

class OwnerShopLoading extends OwnerShopsState {}

class OwnerShopLoaded extends OwnerShopsState {
  final OwnerShopModel shop;
  OwnerShopLoaded(this.shop);
}

class OwnerShopFailure extends OwnerShopsState {
  final String error;
  OwnerShopFailure(this.error);
}
