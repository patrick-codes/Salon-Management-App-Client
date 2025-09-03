part of 'all_appm_bloc.dart';

sealed class AllAppointmentState {}

class AllAppointmentInitial extends AllAppointmentState {}

class AllAppointmentsLoadingState extends AllAppointmentState {}

class AllAppointmentsFetchedState extends AllAppointmentState {
  final List<AppointmentModel?>? appointment;

  AllAppointmentsFetchedState(this.appointment);
}

class AllAppointmentsFetchFailureState extends AllAppointmentState {
  final String errorMessage;

  AllAppointmentsFetchFailureState({required this.errorMessage});
}

class AllAppointmentDeletedSuccesState extends AllAppointmentState {
  final String message;

  AllAppointmentDeletedSuccesState({
    required this.message,
  });
}

class AllAppointmentDeletedFailureState extends AllAppointmentState {
  final String message;

  AllAppointmentDeletedFailureState({required this.message});
}
