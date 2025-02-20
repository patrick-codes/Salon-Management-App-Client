import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/presentation/location/bloc/location_bloc.dart';
import 'package:salonapp_client/salonapp.dart';
import 'presentation/authentication screens/bloc/auth_bloc.dart';

class SalonAppBlocs extends StatelessWidget {
  const SalonAppBlocs({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc()..add(AppStartedEvent()),
        ),
        BlocProvider(
          create: (_) => LocationBloc()..add(LoadLocationEvent()),
        )
      ],
      child: SalonApp(),
    );
  }
}
