import 'package:equatable/equatable.dart';

import '../../domain/entities/girvi.dart';
import 'create_girvi_state.dart';

sealed class CreateGirviEvent extends Equatable {
  const CreateGirviEvent();

  @override
  List<Object?> get props => [];
}

class CreateGirviCustomerSelected extends CreateGirviEvent {
  const CreateGirviCustomerSelected({
    required this.customerId,
    required this.customerName,
    required this.customerNameEn,
    required this.customerMobile,
  });

  final String customerId;
  final String customerName;
  final String customerNameEn;
  final String customerMobile;

  @override
  List<Object?> get props => [customerId, customerName, customerNameEn, customerMobile];
}

class CreateGirviItemAdded extends CreateGirviEvent {
  const CreateGirviItemAdded();
}

class CreateGirviItemRemoved extends CreateGirviEvent {
  const CreateGirviItemRemoved(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class CreateGirviItemUpdated extends CreateGirviEvent {
  const CreateGirviItemUpdated(this.item);

  final GirviItemDraft item;

  @override
  List<Object?> get props => [item];
}

class CreateGirviItemPhotoAdded extends CreateGirviEvent {
  const CreateGirviItemPhotoAdded({required this.itemId, required this.photoPath});

  final String itemId;
  final String photoPath;

  @override
  List<Object?> get props => [itemId, photoPath];
}

class CreateGirviItemPhotoRemoved extends CreateGirviEvent {
  const CreateGirviItemPhotoRemoved({required this.itemId, required this.photoIndex});

  final String itemId;
  final int photoIndex;

  @override
  List<Object?> get props => [itemId, photoIndex];
}

class CreateGirviLtvSelected extends CreateGirviEvent {
  const CreateGirviLtvSelected(this.ltvPercent);

  final double ltvPercent;

  @override
  List<Object?> get props => [ltvPercent];
}

class CreateGirviLoanAmountOverridden extends CreateGirviEvent {
  const CreateGirviLoanAmountOverridden(this.amount);

  final double? amount;

  @override
  List<Object?> get props => [amount];
}

class CreateGirviLoanTermsUpdated extends CreateGirviEvent {
  const CreateGirviLoanTermsUpdated({
    this.interestRate,
    this.interestType,
    this.dueDate,
    this.penaltyRate,
  });

  final double? interestRate;
  final InterestType? interestType;
  final DateTime? dueDate;
  final double? penaltyRate;

  @override
  List<Object?> get props => [interestRate, interestType, dueDate, penaltyRate];
}

class CreateGirviKfsAccepted extends CreateGirviEvent {
  const CreateGirviKfsAccepted(this.accepted);

  final bool accepted;

  @override
  List<Object?> get props => [accepted];
}

class CreateGirviVaultSelected extends CreateGirviEvent {
  const CreateGirviVaultSelected(this.vaultLocation);

  final String vaultLocation;

  @override
  List<Object?> get props => [vaultLocation];
}

class CreateGirviSubmitted extends CreateGirviEvent {
  const CreateGirviSubmitted();
}
