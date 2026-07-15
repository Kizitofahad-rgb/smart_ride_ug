import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.map,
              size: 60,
              color: AppColors.primary,
            ),
            SizedBox(height: 12),
            Text(
              'OpenStreetMap will appear here',
            ),
          ],
        ),
      ),
    );
  }
}