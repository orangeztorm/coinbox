import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_info.dart';

/// Provider for network connectivity status
final networkConnectivityProvider = FutureProvider<bool>((ref) async {
  final networkInfo = NetworkInfoImpl();
  return await networkInfo.isConnected;
});

/// Provider that watches network connectivity and refreshes periodically
final networkStatusProvider = StreamProvider<bool>((ref) async* {
  final networkInfo = NetworkInfoImpl();

  while (true) {
    try {
      final isConnected = await networkInfo.isConnected;
      yield isConnected;

      // Wait 5 seconds before checking again
      await Future.delayed(const Duration(seconds: 5));
    } catch (e) {
      yield false;
      await Future.delayed(const Duration(seconds: 5));
    }
  }
});

/// Provider for one-time network check
final networkCheckProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());
