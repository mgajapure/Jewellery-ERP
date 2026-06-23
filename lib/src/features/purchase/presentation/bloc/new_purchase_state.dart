part of 'new_purchase_bloc.dart';

sealed class NewPurchaseState {
  const NewPurchaseState();
}

final class NewPurchaseInitial extends NewPurchaseState {
  const NewPurchaseInitial();
}

final class NewPurchaseSubmitting extends NewPurchaseState {
  const NewPurchaseSubmitting();
}

final class NewPurchaseSuccess extends NewPurchaseState {
  const NewPurchaseSuccess(this.entry);

  final PurchaseEntry entry;
}

final class NewPurchaseError extends NewPurchaseState {
  const NewPurchaseError(this.message);

  final String message;
}
