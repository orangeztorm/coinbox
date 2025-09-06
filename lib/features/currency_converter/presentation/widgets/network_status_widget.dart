import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/core.dart';

class NetworkStatusWidget extends ConsumerWidget {
  final AppLocalizations localizations;

  const NetworkStatusWidget({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    return networkStatus.when(
      data: (isConnected) {
        if (isConnected) {
          return const SizedBox.shrink(); // Don't show anything when connected
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          color: Colors.red[100],
          child: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red[800], size: 16),
              const SizedBox(width: 8),
              Text(
                localizations.noInternetConnection,
                style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        color: Colors.orange[100],
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[800], size: 16),
            const SizedBox(width: 8),
            Text(
              localizations.networkStatusUnknown,
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
