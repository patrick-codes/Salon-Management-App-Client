part of 'all_appm_bloc.dart';

sealed class AllAppointmentEvent {}

class DeleteAllAppointmentEvent extends AllAppointmentEvent {
  final String id;
  DeleteAllAppointmentEvent({
    required this.id,
  });
}

class ViewAllAppointmentEvent extends AllAppointmentEvent {}

class ViewSingleAppointmentEvent extends AllAppointmentEvent {
  final String? id;

  ViewSingleAppointmentEvent(this.id);
}

class SearchAppointmentEvent extends AllAppointmentEvent {
  final String query;

  SearchAppointmentEvent({required this.query});
}
