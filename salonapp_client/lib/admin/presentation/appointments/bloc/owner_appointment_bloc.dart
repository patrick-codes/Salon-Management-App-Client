import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:salonapp_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/appointment service/appointment_service.dart';
import '../repository/data model/owner_appointment_model.dart';

part 'owner_appointment_events.dart';
part 'owner_appointment_states.dart';

class OwnerAppointmentBloc
    extends Bloc<OwnerAppointmentEvent, OwnerAppointmentState> {
  static OwnerAppointmentServiceHelper appointmentHelper =
      OwnerAppointmentServiceHelper();
  List<OwnerAppointmentModel?>? appointment;
  List<OwnerAppointmentModel>? appointmentList2;
  StreamSubscription? _appointmentSubscription;

  OwnerAppointmentModel? appointmentList;
  List<OwnerAppointmentModel>? appointments = [];
  final firebaseUser = FirebaseAuth.instance;

  OwnerAppointmentBloc() : super(OwnerAppointmentInitial()) {
    on<ViewOwnerAppointmentEvent>(_onViewAppointments);
    on<OwnerAppointmentsUpdatedEvent>(_onAppointmentsUpdated);
    on<SearchOwnerAppointmentEvent>(searchAppointment);
    on<DeleteOwnerAppointmentEvent>(deleteAppointment);
  }

  void onSearchChanged(String query) {
    appointmentList2 = appointments!
        .where((service) => service.shopName!
            .trim()
            .toLowerCase()
            .contains(query.trim().toLowerCase()))
        .toList();
  }

  Future<void> _onViewAppointments(ViewOwnerAppointmentEvent event,
      Emitter<OwnerAppointmentState> emit) async {
    emit(OwnerAppointmentsLoadingState());

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _appointmentSubscription?.cancel();

    final prefs = await SharedPreferences.getInstance();
    final seenIds = prefs.getStringList('seen_appointment_ids') ?? [];

    _appointmentSubscription = FirebaseFirestore.instance
        .collection('appointments')
        .where('ownerID', isEqualTo: currentUserId)
        .snapshots()
        .listen((snapshot) {
      final appointments = snapshot.docs.map((doc) {
        return OwnerAppointmentModel.fromMap(doc.data(), id: doc.id);
      }).toList();

      // Calculate unread count
      final unread = appointments.where((a) => !seenIds.contains(a.id)).length;

      add(OwnerAppointmentsUpdatedEvent(
        appointmentModel: appointments,
        unreadCount: unread,
      ));

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final newAppointment = OwnerAppointmentModel.fromMap(
              change.doc.data()!,
              id: change.doc.id);

          if (!seenIds.contains(newAppointment.id)) {
            _showLocalNotification(newAppointment);
          }
        }
      }
    });
  }

  Future<void> searchAppointment(SearchOwnerAppointmentEvent event,
      Emitter<OwnerAppointmentState> emit) async {
    try {
      emit(OwnerAppointmentsLoadingState());
      if (event.query.isNotEmpty) {
        onSearchChanged(event.query);
        emit(OwnerAppointmentsFetchedState(appointmentList2));
      }
    } catch (e) {
      print(e);
    }
  }

  void _onAppointmentsUpdated(OwnerAppointmentsUpdatedEvent event,
      Emitter<OwnerAppointmentState> emit) {
    emit(OwnerAppointmentsFetchedState(event.appointmentModel,
        unreadCount: event.unreadCount));
  }

  void _showLocalNotification(OwnerAppointmentModel appointment) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'appointments_channel',
      'Appointments',
      channelDescription: 'Channel for appointment notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      appointment.hashCode,
      'New Appointment Alert!!',
      'Received from ${appointment.phone ?? 'a client.'}',
      notificationDetails,
    );
  }

  @override
  Future<void> close() {
    _appointmentSubscription?.cancel();
    return super.close();
  }

  Future<OwnerAppointmentModel?> deleteAppointment(
      DeleteOwnerAppointmentEvent event,
      Emitter<OwnerAppointmentState> emit) async {
    emit(OwnerAppointmentsLoadingState());
    try {
      if (event.id.isNotEmpty) {
        appointmentList =
            await appointmentHelper.deleteSingleAppointment(event.id);
        emit(OwnerAppointmentDeletedSuccesState(
            message: 'Appointment deleted succesfully'));
        debugPrint("Appointment deleted succesfully");
        emit(OwnerAppointmentsFetchedState(appointment));
      } else if (event.id.isEmpty) {
        emit(OwnerAppointmentDeletedFailureState(
            message: 'Deletion error: Appointment Id not found'));
        debugPrint("Deletion error: Appointment Id not found");
      }
    } on FirebaseAuthException catch (error) {
      emit(OwnerAppointmentDeletedFailureState(message: error.toString()));
      debugPrint("Deletion error:  ${error.toString()}");
    } catch (error) {
      emit(OwnerAppointmentDeletedFailureState(message: error.toString()));
      debugPrint("Deletion error: ${error.toString()}");
    }
    return appointmentList;
  }
}
