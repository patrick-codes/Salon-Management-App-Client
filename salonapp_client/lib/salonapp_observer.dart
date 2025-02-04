import "package:flutter_bloc/flutter_bloc.dart";
import "package:logger/logger.dart";

final logger = Logger(
  printer: PrettyPrinter(methodCount: 0, lineLength: 1000),
);

class SalonappObserver extends BlocObserver {
  const SalonappObserver();

  @override
  void onError(BlocBase<void> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e(bloc.toString() + error.toString() + stackTrace.toString());
  }

  @override
  void onCreate(BlocBase<void> bloc) {
    super.onCreate(bloc);
    logger.t("${bloc.runtimeType} created");
  }

  @override
  void onClose(BlocBase<void> bloc) {
    super.onClose(bloc);
    logger.t("${bloc.runtimeType} disposed");
  }
}
