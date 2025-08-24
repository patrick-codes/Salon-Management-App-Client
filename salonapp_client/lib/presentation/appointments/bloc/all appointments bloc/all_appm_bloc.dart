import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/appointment service/appointment_service.dart';
import '../../repository/data model/appointment_model.dart';
part 'all_appm_event.dart';
part 'all_appm_state.dart';

class AllAppointmentBloc
    extends Bloc<AllAppointmentEvent, AllAppointmentState> {
  static AppointmentServiceHelper appointmentHelper =
      AppointmentServiceHelper();
  List<AppointmentModel?>? appointment;
  List<AppointmentModel>? appointmentList2;

  AppointmentModel? appointmentList;
  List<AppointmentModel>? appointments = [];
  final firebaseUser = FirebaseAuth.instance;
  AllAppointmentBloc() : super(AllAppointmentInitial()) {
    on<ViewAllAppointmentEvent>(fetchAppointments);
    on<DeleteAllAppointmentEvent>(deleteAppointment);
  }

  Future<List<AppointmentModel?>?> fetchAppointments(
      ViewAllAppointmentEvent event, Emitter<AllAppointmentState> emit) async {
    emit(AllAppointmentsLoadingState());
    debugPrint("Current User ID: ${firebaseUser.currentUser!.uid}");
    try {
      appointment =
          await appointmentHelper.myAppointments(firebaseUser.currentUser!.uid);
      emit(AllAppointmentsFetchedState(appointment));
      debugPrint("Appointments fetched succesfully");

      if (appointment!.isEmpty) {
        emit(AllAppointmentsFetchFailureState(
            errorMessage: 'You have no appointments'));
      }
    } on FirebaseAuthException catch (error) {
      emit(AllAppointmentsFetchFailureState(errorMessage: error.toString()));
      debugPrint("Error: $error");
    } catch (error) {
      emit(AllAppointmentsFetchFailureState(errorMessage: error.toString()));
      debugPrint("Error: $error");
    }
    return appointment;
  }

  Future<AppointmentModel?> deleteAppointment(DeleteAllAppointmentEvent event,
      Emitter<AllAppointmentState> emit) async {
    emit(AllAppointmentsLoadingState());
    try {
      if (event.id.isNotEmpty) {
        appointmentList =
            await appointmentHelper.deleteSingleAppointment(event.id);

        emit(AllAppointmentDeletedSuccesState(
            message: 'Appointment deleted succesfully'));
        debugPrint("Appointment deleted succesfully");
        emit(AllAppointmentsFetchedState(appointment));
      } else if (event.id.isEmpty) {
        emit(AllAppointmentDeletedFailureState(
            message: 'Deletion error: Appointment Id not found'));
        debugPrint("Deletion error: Appointment Id not found");
      }
    } on FirebaseAuthException catch (error) {
      emit(AllAppointmentDeletedFailureState(message: error.toString()));
      debugPrint("Deletion error:  ${error.toString()}");
    } catch (error) {
      emit(AllAppointmentDeletedFailureState(message: error.toString()));
      debugPrint("Deletion error: ${error.toString()}");
    }
    return appointmentList;
  }
}
