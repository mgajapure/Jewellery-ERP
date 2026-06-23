import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

@injectable
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({required AuthRepository repository})
      : _repository = repository,
        super(const OtpInitial()) {
    on<OtpStarted>(_onStarted);
    on<OtpTimerTicked>(_onTimerTicked);
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResend);
  }

  final AuthRepository _repository;
  StreamSubscription<int>? _timerSub;

  void _onStarted(OtpStarted event, Emitter<OtpState> emit) {
    emit(OtpEntry(
      mobile: event.mobile,
      maskedMobile: event.maskedMobile,
      requestId: event.requestId,
      secondsLeft: event.countdownSeconds,
      attemptsLeft: 5,
    ));
    _startTimer(event.countdownSeconds);
  }

  void _startTimer(int seconds) {
    _timerSub?.cancel();
    _timerSub = Stream.periodic(const Duration(seconds: 1), (x) => seconds - x - 1)
        .take(seconds)
        .listen((s) => add(OtpTimerTicked(s)));
  }

  void _onTimerTicked(OtpTimerTicked event, Emitter<OtpState> emit) {
    if (state is OtpEntry) {
      emit((state as OtpEntry).copyWith(secondsLeft: event.secondsLeft));
    }
  }

  Future<void> _onSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (state is! OtpEntry) return;
    final current = state as OtpEntry;
    if (current.isVerifying) return;

    emit(current.copyWith(isVerifying: true, clearError: true));

    final result = await _repository.verifyOtp(
      requestId: current.requestId,
      otp: event.otp,
      mobile: current.mobile,
    );

    result.when(
      success: (session) {
        _timerSub?.cancel();
        emit(OtpSuccess(session));
      },
      failure: (error) {
        if (error.message == '__registration_pending__') {
          _timerSub?.cancel();
          emit(const OtpRegistrationPending());
        } else {
          final remaining = current.attemptsLeft - 1;
          emit(current.copyWith(
            isVerifying: false,
            attemptsLeft: remaining,
            errorMessage: error.message,
          ));
        }
      },
    );
  }

  Future<void> _onResend(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    if (state is! OtpEntry) return;
    final current = state as OtpEntry;
    if (current.isResending) return;

    emit(current.copyWith(isResending: true, clearError: true));

    final result = await _repository.requestOtp(current.mobile);

    result.when(
      success: (requestId) {
        emit(current.copyWith(
          requestId: requestId,
          secondsLeft: 30,
          isResending: false,
          attemptsLeft: 5,
          clearError: true,
        ));
        _startTimer(30);
      },
      failure: (error) => emit(current.copyWith(
        isResending: false,
        errorMessage: error.message,
      )),
    );
  }

  @override
  Future<void> close() {
    _timerSub?.cancel();
    return super.close();
  }
}
