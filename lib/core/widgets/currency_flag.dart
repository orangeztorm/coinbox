import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/currency_service.dart';

class CurrencyFlag extends StatelessWidget {
  final String currencyCode;
  final double size;

  const CurrencyFlag({super.key, required this.currencyCode, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final flagUrl = CurrencyService.getFlagUrl(currencyCode, size: 320);

    if (flagUrl.isEmpty) {
      return _buildFallbackIcon();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: flagUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          // Memory cache configuration - optimize for display size
          memCacheWidth: size.toInt(),
          memCacheHeight: size.toInt(),
          // Disk cache configuration with unique key
          cacheKey: 'flag_${currencyCode}_${size.toInt()}',
          // Error widget
          errorWidget: (context, url, error) => _buildFallbackIcon(),
          // Smooth fade in animation
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 100),
          // Progress indicator for loading (handles both loading and placeholder)
          progressIndicatorBuilder: (context, url, progress) {
            return _buildLoadingPlaceholder();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]!),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    // Check if it's a special currency that needs custom icon
    if (['XDR', 'XOF', 'XAF'].contains(currencyCode)) {
      return SpecialCurrencyIcons.getSpecialIcon(currencyCode, size);
    }

    // Default fallback with currency code initials
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[100],
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Text(
          currencyCode.length >= 2
              ? currencyCode.substring(0, 2)
              : currencyCode,
          style: TextStyle(
            fontSize: size * 0.25,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ),
    );
  }
}
