import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/presentation/appointments/repository/appointment%20service/appointment_service.dart';
import 'package:salonapp_client/presentation/appointments/repository/data%20model/appointment_model.dart';

part 'appointment_events.dart';
part 'appointment_states.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  static AppointmentServiceHelper appointmentHelper =
      AppointmentServiceHelper();
  final firebaseUser = FirebaseAuth.instance;
  AppointmentBloc() : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(createAppointment);
    on<ViewAppointmentEvent>(fetchAppointments);
    // on<SearchShopEvent>(searchAppointment);
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
      //emit(AppointmentsLoadingState());
      debugPrint("Creating Apppointment service......");

      final appointments = AppointmentModel(
        userId: firebaseUser.currentUser!.uid,
        amount: event.amount,
        shopName: event.shopName,
        category: event.category,
        appointmentTime: event.appointmentTime,
        appointmentDate: event.appointmentDate,
        phone: event.phone,
        servicesType: event.servicesType,
      );
      emit(AppointmentsLoadingState());

      appointmentHelper.createAppointment(appointments);
      emit(AppointmentCreatedSuccesState(
          message: 'Appointment service created succesfuly!!'));
      debugPrint("Appointment service created succesfuly!!");
    } catch (e) {
      emit(AppointmentCreateFailureState(error: e.toString()));
      debugPrint(e.toString());
    }
  }

  Future<List<AppointmentModel>?> fetchAppointments(
      ViewAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentsLoadingState());
    try {} catch (error) {
      debugPrint("Error: $error");
    }
    return null;
  }
}
