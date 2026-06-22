import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app/jewellery_erp_app.dart';
import 'src/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure dependency injection (get_it + injectable).
  await configureDependencies();

  // Optional: log BLoC transitions during development.
  Bloc.observer = _AppBlocObserver();

  runApp(const JewelleryErpApp());
}

class _AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print('BLOC: ${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // ignore: avoid_print
    print('BLOC ERROR: ${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }
}
