part of 'bin_to_bin_transfer_bloc.dart';

abstract class BinToBinTransferState extends Equatable {
  const BinToBinTransferState();

  @override
  List<Object?> get props => [];
}

class BinToBinTransferInitial extends BinToBinTransferState {}

class BinToBinTransferLoading extends BinToBinTransferState {}

class BinToBinTransferSuccess extends BinToBinTransferState {
  final ApiResponse<bool> response;

  const BinToBinTransferSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class BinToBinTransferFailure extends BinToBinTransferState {
  final String message;

  const BinToBinTransferFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
