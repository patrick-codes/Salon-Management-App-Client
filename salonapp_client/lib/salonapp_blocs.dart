import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/presentation/appointments/bloc/appointment_bloc.dart';
import 'package:salonapp_client/presentation/location/bloc/location_bloc.dart';
import 'package:salonapp_client/salonapp.dart';
import 'presentation/authentication screens/bloc/auth_bloc.dart';
import 'presentation/shops/bloc/home shop bloc/h_shops_bloc.dart';
import 'presentation/shops/bloc/shops_bloc.dart';

class SalonAppBlocs extends StatelessWidget {
  const SalonAppBlocs({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AppStartedEvent()),
        ),
        BlocProvider(
          create: (context) => LocationBloc()..add(LoadLocationEvent()),
        ),
        BlocProvider(
          create: (context) =>
              ShopsBloc(context.read<LocationBloc>())..add(ViewShopsEvent()),
        ),
        BlocProvider(
          create: (context) => HomeShopsBloc(context.read<AuthBloc>())
            ..add(ViewHomeShopsEvent()),
        ),
        BlocProvider(
          create: (context) => AppointmentBloc()..add(ViewAppointmentEvent()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeShopsBloc(context.read<AuthBloc>())
              ..add(ViewHomeShopsEvent()),
          )
        ],
        child: SalonApp(),
      ),
    );
  }
}
