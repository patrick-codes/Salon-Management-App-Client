import 'dart:math';

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
  List<AppointmentModel>? appointment;
  List<AppointmentModel>? appointments = [];
  final firebaseUser = FirebaseAuth.instance;
  AppointmentBloc() : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(createAppointment);
    on<ViewAppointmentEvent>(fetchAppointments);
    on<SearchAppointmentEvent>(searchAppointment);
    // on<ViewSingleShopEvent>(fetchSingleAppointment);
  }
  void onSearchChanged(String query) {
    appointment = appointments!
        .where((service) => service.shopName!
            .trim()
            .toLowerCase()
            .contains(query.trim().toLowerCase()))
        .toList();
  }

  Future<void> searchAppointment(
      SearchAppointmentEvent event, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentsLoadingState());
      if (event.query.isNotEmpty) {
        onSearchChanged(event.query);
        emit(AppointmentsFetchedState(appointment));
      }
    } catch (e) {
      print(e);
    }
  }

  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  String generateBookingCode() {
    final now = DateTime.now();
    String datePart =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String randomPart = _generateRandomString(4);
    return "$datePart$randomPart";
  }

  Future<void> createAppointment(
      CreateAppointmentEvent event, Emitter<AppointmentState> emit) async {
    try {
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
        bookingCode: event.bookingCode,
      );
      emit(AppointmentsLoadingState());

      appointmentHelper.createAppointment(appointments);
      String codegen = generateBookingCode();
      emit(AppointmentCreatedSuccesState(
          message: 'Appointment service created succesfuly!!', code: codegen));
      debugPrint("Appointment service created succesfuly.");
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
