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
  List<AppointmentModel>? appointmentList;
  List<AppointmentModel>? appointments = [];
  final firebaseUser = FirebaseAuth.instance;
  AppointmentBloc() : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(createAppointment);
    on<ViewAppointmentEvent>(fetchAppointments);
    on<SearchAppointmentEvent>(searchAppointment);
    // on<ViewSingleShopEvent>(fetchSingleAppointment);
  }
  void onSearchChanged(String query) {
    appointmentList = appointments!
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
        emit(AppointmentsFetchedState(appointmentList));
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

  String shopConcat(String fullName) {
    List<String> words = fullName.trim().split(RegExp(r'\s+'));
    if (words.length < 2) return words[0][0].toUpperCase();

    return words[0][0].toUpperCase() + words[1][0].toUpperCase();
  }

  String generateBookingCode(String shopname) {
    final now = DateTime.now();
    String datePart =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String randomPart = _generateRandomString(4);
    String shopconcat = shopConcat(shopname);
    return "$shopconcat$datePart$randomPart";
  }

  Future<void> createAppointment(
      CreateAppointmentEvent event, Emitter<AppointmentState> emit) async {
    try {
      emit(AppointmentsLoadingState());
      debugPrint("Creating Apppointment service......");

      String codegen = generateBookingCode(event.shopName.toString());

      final appointments = AppointmentModel(
        userId: firebaseUser.currentUser!.uid,
        amount: event.amount,
        shopName: event.shopName,
        category: event.category,
        appointmentTime: event.appointmentTime,
        appointmentDate: event.appointmentDate,
        phone: event.phone,
        servicesType: event.servicesType,
        bookingCode: codegen,
      );

      appointmentHelper.createAppointment(appointments);
      emit(AppointmentCreatedSuccesState(
          message: 'Appointment service created succesfuly!!', code: codegen));
      debugPrint("Appointment service created succesfuly.");
    } on FirebaseAuthException catch (error) {
      debugPrint("❌ Firebase Error: $error");
      emit(AppointmentCreateFailureState(error: e.toString()));
    } catch (e) {
      emit(AppointmentCreateFailureState(error: e.toString()));
      debugPrint(e.toString());
    }
  }

  Future<List<AppointmentModel>?> fetchAppointments(
      ViewAppointmentEvent event, Emitter<AppointmentState> emit) async {
    emit(AppointmentsLoadingState());
    try {
      appointment = await appointmentHelper.fetchAllappointments();
      emit(AppointmentsFetchedState(appointment));
      debugPrint("Appointments fetched succesfully");

      if (appointment!.isEmpty) {
        emit(AppointmentsFetchFailureState(errorMessage: 'Empty List'));
      }
    } on FirebaseAuthException catch (error) {
      emit(AppointmentsFetchFailureState(errorMessage: error.toString()));
      debugPrint("Error: $error");
    } catch (error) {
      emit(AppointmentsFetchFailureState(errorMessage: error.toString()));
      debugPrint("Error: $error");
    }
    return appointment;
  }
}
