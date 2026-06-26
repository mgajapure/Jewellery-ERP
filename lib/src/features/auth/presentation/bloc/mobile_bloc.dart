import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repository.dart';
import 'mobile_event.dart';
import 'mobile_state.dart';

@injectable
class MobileBloc extends Bloc<MobileEvent, MobileState> {
  MobileBloc({required AuthRepository repository})
      : _repository = repository,
        super(const MobileInitial()) {
    on<MobileSubmit>(_onSubmit);
  }

  final AuthRepository _repository;

  Future<void> _onSubmit(
    MobileSubmit event,
    Emitter<MobileState> emit,
  ) async {
    emit(const MobileSubmitting());
    final result = await _repository.requestOtp(event.mobile);
    result.when(
      success: (requestId) {
        final digits = event.mobile.replaceAll(RegExp(r'\D'), '');
        final masked = digits.length >= 10
            ? '+91 ${digits.substring(0, 2)}xxx xxx${digits.substring(7)}'
            : '+91 xxxxxxxx${digits.substring(digits.length - 2)}';
        emit(MobileOtpSent(
          requestId: requestId,
          mobile: digits,
          maskedMobile: masked,
        ));
      },
      failure: (error) => emit(MobileError(error.message)),
    );
  }
}
