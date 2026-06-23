import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/girvi_repository.dart';
import 'girvi_detail_event.dart';
import 'girvi_detail_state.dart';

@injectable
class GirviDetailBloc extends Bloc<GirviDetailEvent, GirviDetailState> {
  GirviDetailBloc({required GirviRepository repository})
      : _repository = repository,
        super(const GirviDetailInitial()) {
    on<LoadGirviDetail>(_onLoadDetail);
    on<MakeGirviPayment>(_onMakePayment);
    on<RenewGirviRequested>(_onRenew);
    on<RedeemGirviRequested>(_onRedeem);
    on<CompleteGirviAuction>(_onCompleteAuction);
  }

  final GirviRepository _repository;

  Future<void> _onLoadDetail(
    LoadGirviDetail event,
    Emitter<GirviDetailState> emit,
  ) async {
    emit(const GirviDetailLoading());
    final result = await _repository.getGirviById(event.id);
    result.when(
      success: (girvi) => emit(GirviDetailLoaded(girvi)),
      failure: (error) => emit(GirviDetailError(error.message)),
    );
  }

  Future<void> _onMakePayment(
    MakeGirviPayment event,
    Emitter<GirviDetailState> emit,
  ) async {
    final current = state;
    if (current is! GirviDetailLoaded) return;
    emit(GirviOperationLoading(current.girvi));
    final paymentResult = await _repository.makePayment(
      event.girviId,
      event.request,
    );
    if (paymentResult.isFailure) {
      emit(GirviOperationFailure(
        current.girvi,
        paymentResult.errorOrNull!.message,
      ));
      return;
    }
    final refreshed = await _repository.getGirviById(event.girviId);
    refreshed.when(
      success: (updated) =>
          emit(GirviOperationSuccess(updated, 'Payment recorded successfully.')),
      failure: (_) => emit(
        GirviOperationSuccess(current.girvi, 'Payment recorded successfully.'),
      ),
    );
  }

  Future<void> _onRenew(
    RenewGirviRequested event,
    Emitter<GirviDetailState> emit,
  ) async {
    final current = state;
    if (current is! GirviDetailLoaded) return;
    emit(GirviOperationLoading(current.girvi));
    final result = await _repository.renewGirvi(
      event.girviId,
      event.request,
    );
    result.when(
      success: (updated) => emit(
        GirviOperationSuccess(updated, 'Girvi renewed successfully.'),
      ),
      failure: (error) => emit(
        GirviOperationFailure(current.girvi, error.message),
      ),
    );
  }

  Future<void> _onRedeem(
    RedeemGirviRequested event,
    Emitter<GirviDetailState> emit,
  ) async {
    final current = state;
    if (current is! GirviDetailLoaded) return;
    emit(GirviOperationLoading(current.girvi));
    final redeemResult = await _repository.redeemGirvi(event.girviId);
    if (redeemResult.isFailure) {
      emit(GirviOperationFailure(
        current.girvi,
        redeemResult.errorOrNull!.message,
      ));
      return;
    }
    final refreshed = await _repository.getGirviById(event.girviId);
    refreshed.when(
      success: (updated) =>
          emit(GirviOperationSuccess(updated, 'Girvi redeemed successfully.')),
      failure: (_) => emit(
        GirviOperationSuccess(current.girvi, 'Girvi redeemed successfully.'),
      ),
    );
  }

  Future<void> _onCompleteAuction(
    CompleteGirviAuction event,
    Emitter<GirviDetailState> emit,
  ) async {
    final current = state;
    if (current is! GirviDetailLoaded) return;
    emit(GirviOperationLoading(current.girvi));
    final result = await _repository.completeAuction(
      event.girviId,
      event.request,
    );
    result.when(
      success: (_) => emit(
        GirviOperationSuccess(current.girvi, 'Auction completed successfully.'),
      ),
      failure: (error) => emit(
        GirviOperationFailure(current.girvi, error.message),
      ),
    );
  }
}
