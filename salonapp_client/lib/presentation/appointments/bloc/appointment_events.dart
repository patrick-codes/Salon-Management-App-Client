part of 'appointment_bloc.dart';

sealed class AppointmentEvent {}

class CreateAppointmentEvent extends AppointmentEvent {
  String? appointmentId;

  CreateAppointmentEvent({
    this.appointmentId,
  });
}

class DeleteAppointmentEvent extends AppointmentEvent {
  final String message;
  DeleteAppointmentEvent({
    required this.message,
  });
}

class ViewAppointmentEvent extends AppointmentEvent {}

class ViewSingleAppointmentEvent extends AppointmentEvent {
  final String? id;

  ViewSingleAppointmentEvent(this.id);
}

class SearchAppointmentEvent extends AppointmentEvent {
  final String query;

  SearchAppointmentEvent({required this.query});
}
