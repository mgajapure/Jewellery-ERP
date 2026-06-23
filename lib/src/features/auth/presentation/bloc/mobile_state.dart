import 'package:equatable/equatable.dart';

sealed class MobileState extends Equatable {
  const MobileState();

  @override
  List<Object?> get props => [];
}

class MobileInitial extends MobileState {
  const MobileInitial();
}

class MobileSubmitting extends MobileState {
  const MobileSubmitting();
}

class MobileOtpSent extends MobileState {
  const MobileOtpSent({
    required this.requestId,
    required this.mobile,
    required this.maskedMobile,
  });

  final String requestId;
  final String mobile;
  final String maskedMobile;

  @override
  List<Object?> get props => [requestId, mobile];
}

class MobileError extends MobileState {
  const MobileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
