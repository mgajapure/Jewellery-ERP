import 'package:equatable/equatable.dart';

sealed class MobileEvent extends Equatable {
  const MobileEvent();

  @override
  List<Object?> get props => [];
}

class MobileSubmit extends MobileEvent {
  const MobileSubmit(this.mobile);

  final String mobile;

  @override
  List<Object?> get props => [mobile];
}
