import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/presentation/appointments/repository/appointment%20service/appointment_service.dart';
import 'package:salonapp_client/presentation/appointments/repository/data%20model/appointment_model.dart';

part 'appointment_events.dart';
part 'appointment_states.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  static AppointmentServiceHelper appointmentHelper =
      AppointmentServiceHelper();

  AppointmentBloc() : super(AppointmentInitial()) {
    on<ViewAppointmentEvent>(fetchAppointments);
    // on<SearchShopEvent>(searchAppointment);
    on<CreateAppointmentEvent>(createAppointment);
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
      debugPrint("Creating Apppointment service......");

      final appointment = AppointmentModel(
        shopName: event.shopName,
        category: event.category,
        appointmentTime: event.appointmentTime,
        appointmentDate: event.appointmentDate,
        phone: event.phone,
        servicesType: event.servicesType,
      );
      appointmentHelper.createAppointment(appointment);
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
