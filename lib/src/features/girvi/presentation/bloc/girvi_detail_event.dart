import 'package:equatable/equatable.dart';

import '../../domain/repositories/girvi_repository.dart';

sealed class GirviDetailEvent extends Equatable {
  const GirviDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadGirviDetail extends GirviDetailEvent {
  const LoadGirviDetail(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class MakeGirviPayment extends GirviDetailEvent {
  const MakeGirviPayment({required this.girviId, required this.request});

  final String girviId;
  final PaymentRequest request;

  @override
  List<Object?> get props => [girviId];
}

class RenewGirviRequested extends GirviDetailEvent {
  const RenewGirviRequested({required this.girviId, required this.request});

  final String girviId;
  final RenewalRequest request;

  @override
  List<Object?> get props => [girviId];
}

class RedeemGirviRequested extends GirviDetailEvent {
  const RedeemGirviRequested(this.girviId);

  final String girviId;

  @override
  List<Object?> get props => [girviId];
}

class CompleteGirviAuction extends GirviDetailEvent {
  const CompleteGirviAuction({required this.girviId, required this.request});

  final String girviId;
  final AuctionRequest request;

  @override
  List<Object?> get props => [girviId];
}
