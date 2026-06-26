import 'package:equatable/equatable.dart';

import '../../domain/entities/girvi.dart';

sealed class GirviDetailState extends Equatable {
  const GirviDetailState();

  @override
  List<Object?> get props => [];
}

class GirviDetailInitial extends GirviDetailState {
  const GirviDetailInitial();
}

class GirviDetailLoading extends GirviDetailState {
  const GirviDetailLoading();
}

class GirviDetailLoaded extends GirviDetailState {
  const GirviDetailLoaded(this.girvi);

  final Girvi girvi;

  @override
  List<Object?> get props => [girvi];
}

class GirviDetailError extends GirviDetailState {
  const GirviDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class GirviOperationLoading extends GirviDetailState {
  const GirviOperationLoading(this.girvi);

  final Girvi girvi;

  @override
  List<Object?> get props => [girvi];
}

class GirviOperationSuccess extends GirviDetailState {
  const GirviOperationSuccess(this.girvi, this.message);

  final Girvi girvi;
  final String message;

  @override
  List<Object?> get props => [girvi, message];
}

class GirviOperationFailure extends GirviDetailState {
  const GirviOperationFailure(this.girvi, this.message);

  final Girvi girvi;
  final String message;

  @override
  List<Object?> get props => [girvi, message];
}
