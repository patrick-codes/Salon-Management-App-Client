// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'owner_appointment_bloc.dart';

sealed class OwnerAppointmentEvent {}

class CreateOwnerAppointmentEvent extends OwnerAppointmentEvent {
  final double? amount;
  final String? userId;
  final String? shopName;
  final String? category;
  final TimeOfDay? appointmentTime;
  final DateTime? appointmentDate;
  final String? phone;
  final String? servicesType;
  final String? bookingCode;
  final String? img;
  final String? location;

  CreateOwnerAppointmentEvent({
    required this.amount,
    this.userId,
    required this.shopName,
    required this.category,
    required this.appointmentTime,
    required this.appointmentDate,
    required this.phone,
    required this.servicesType,
    this.bookingCode,
    required this.img,
    this.location,
  });
}

class DeleteOwnerAppointmentEvent extends OwnerAppointmentEvent {
  final String id;
  DeleteOwnerAppointmentEvent({
    required this.id,
  });
}

class ViewOwnerAppointmentEvent extends OwnerAppointmentEvent {}

class ViewSingleOwnerAppointmentEvent extends OwnerAppointmentEvent {
  final String? id;

  ViewSingleOwnerAppointmentEvent(this.id);
}

class SearchOwnerAppointmentEvent extends OwnerAppointmentEvent {
  final String query;

  SearchOwnerAppointmentEvent({required this.query});
}

class OwnerAppointmentsUpdatedEvent extends OwnerAppointmentEvent {
  final List<OwnerAppointmentModel> appointmentModel;
  final int unreadCount;

  OwnerAppointmentsUpdatedEvent(
      {required this.appointmentModel, required this.unreadCount});
}

class OwnerMarkAppointmentsAsSeenEvent extends OwnerAppointmentEvent {}
