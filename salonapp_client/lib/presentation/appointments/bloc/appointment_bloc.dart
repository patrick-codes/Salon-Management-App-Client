import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'appointment_events.dart';
part 'appointment_states.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(AppointmentInitial()) {
    // on<ViewShopsEvent>(fetchAppointment);
    // on<SearchShopEvent>(searchAppointment);
    // on<CreateAppointmentEvent>(createAppointment);
    // on<ViewSingleShopEvent>(fetchSingleAppointment);
  }
  // void onSearchChanged(String query) {
  //   serviceman = serviceman2!
  //       .where((servicemen) => servicemen.shopName!
  //           .trim()
  //           .toLowerCase()
  //           .contains(query.trim().toLowerCase()))
  //       .toList();
  // }

  // Future<void> searchAppointment(
  //     SearchShopEvent event, Emitter<ShopsState> emit) async {
  //   try {
  //     emit(ShopsLoadingState());
  //     if (event.query.isNotEmpty) {
  //       onSearchChanged(event.query);
  //       emit(ShopsFetchedState(shop: serviceman!));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> createAppointment(
      CreateAppointmentEvent event, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentsLoadingState());
      debugPrint("Creating shop service......");
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
