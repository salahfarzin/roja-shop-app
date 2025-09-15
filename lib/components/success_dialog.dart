import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final int? count;
  final String? text;
  const SuccessDialog({super.key, this.count, this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outermost circle (largest, most transparent)
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  229,
                  147,
                  69,
                ).withAlpha((0.18 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
            // Middle circle (medium size, medium opacity)
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  197,
                  121,
                  34,
                ).withAlpha((0.32 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
            // Main tick circle and content
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    text ?? 'success'.tr(),
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ) ??
                        TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
