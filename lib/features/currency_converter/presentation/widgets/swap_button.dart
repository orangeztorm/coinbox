import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SwapButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Positioned.fill(child: Divider(color: AppColors.divider)),
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryHeader,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryHeader.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
