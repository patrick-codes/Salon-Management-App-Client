// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'appointment_bloc.dart';

sealed class AppointmentEvent {}

class CreateAppointmentEvent extends AppointmentEvent {
  String? appointmentId;
  final double? amount;
  final String? userId;
  final String? shopName;
  final String? category;
  final TimeOfDay? appointmentTime;
  final DateTime? appointmentDate;
  final String? phone;
  final String? servicesType;

  CreateAppointmentEvent({
    this.appointmentId,
    required this.amount,
    this.userId,
    required this.shopName,
    required this.category,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.phone,
    required this.servicesType,
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
