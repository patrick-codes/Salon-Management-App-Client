import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salonapp_client/salonapp.dart';

import 'presentation/appointments/bloc/auth_bloc.dart';

class SalonAppBlocs extends StatelessWidget {
  const SalonAppBlocs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: SalonApp(),
    );
  }
}
