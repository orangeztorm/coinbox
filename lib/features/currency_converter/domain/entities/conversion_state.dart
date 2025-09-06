/// Represents the different states of currency conversion
enum ConversionState {
  /// Initial state - no conversion has been attempted
  initial,

  /// Loading state - conversion is in progress
  loading,

  /// Success state - conversion completed successfully
  success,

  /// Failure state - conversion failed
  failure,
}

/// Extension to provide helpful methods for ConversionState
extension ConversionStateExtension on ConversionState {
  /// Returns true if the state is loading
  bool get isLoading => this == ConversionState.loading;

  /// Returns true if the state is success
  bool get isSuccess => this == ConversionState.success;

  /// Returns true if the state is failure
  bool get isFailure => this == ConversionState.failure;

  /// Returns true if the state is initial
  bool get isInitial => this == ConversionState.initial;
}
