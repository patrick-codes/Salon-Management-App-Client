part of 'owner_appointment_bloc.dart';

sealed class OwnerAppointmentState {}

class OwnerAppointmentInitial extends OwnerAppointmentState {}

class OwnerAppointmentsLoadingState extends OwnerAppointmentState {}

class OwnerAppointmentsFetchedState extends OwnerAppointmentState {
  final List<OwnerAppointmentModel?>? appointment;
  final int unreadCount;

  OwnerAppointmentsFetchedState(this.appointment, {this.unreadCount = 0});
}

class SingleOwnerAppointmentsFetchedState extends OwnerAppointmentState {
  final List<OwnerAppointmentModel>? appointment;

  SingleOwnerAppointmentsFetchedState(this.appointment);
}

class OwnerAppointmentsFetchFailureState extends OwnerAppointmentState {
  final String errorMessage;

  OwnerAppointmentsFetchFailureState({required this.errorMessage});
}

class OwnerAppointmentCreatedSuccesState extends OwnerAppointmentState {
  final String message;
  final String code;

  OwnerAppointmentCreatedSuccesState({
    required this.message,
    required this.code,
  });
}

class OwnerAppointmentCodeCreatedSuccesState extends OwnerAppointmentState {
  final String code;

  OwnerAppointmentCodeCreatedSuccesState({
    required this.code,
  });
}

class OwnerAppointmentCreateFailureState extends OwnerAppointmentState {
  final String error;

  OwnerAppointmentCreateFailureState({required this.error});
}

class OwnerAppointmentDeletedSuccesState extends OwnerAppointmentState {
  final String message;

  OwnerAppointmentDeletedSuccesState({
    required this.message,
  });
}

class OwnerAppointmentDeletedFailureState extends OwnerAppointmentState {
  final String message;

  OwnerAppointmentDeletedFailureState({required this.message});
}

class OwnerSearchSuccesState extends OwnerAppointmentState {
  final String message;

  OwnerSearchSuccesState({required this.message});
}

class OwnerSeachFailureState extends OwnerAppointmentState {
  final String error;

  OwnerSeachFailureState({required this.error});
}

class EmptyOwnerAppointmentState extends OwnerAppointmentState {
  final String message;

  EmptyOwnerAppointmentState({required this.message});
}
