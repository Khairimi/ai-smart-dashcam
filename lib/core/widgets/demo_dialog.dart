import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Dialog for actions whose real implementation (calls, dispatch, sharing,
/// recording storage …) is not part of this prototype. Makes the demo status
/// explicit instead of pretending the action happened.
Future<void> showDemoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text('$message\n\nDEMO / SIMULATED — no real action was taken.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// DEMO list of sample items (recordings, incidents …). Static sample data only.
Future<void> showSampleListDialog(
  BuildContext context, {
  required String title,
  required List<(String, String)> items,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 340,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final i in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    const Icon(Icons.play_circle_outline,
                        color: AppColors.blueSlate),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(i.$1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text(i.$2, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ]),
                ),
              const SizedBox(height: 4),
              const Text('DEMO sample data — nothing here is a real recording.',
                  style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// DEMO "Police Contact" screen shown at the end of the Voice SOS simulation.
/// Nothing is dialled, sent or recorded.
Future<void> showPoliceContactDemo(BuildContext context, {String? phrase}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.local_police_outlined,
          color: AppColors.redSos, size: 36),
      title: const Text('Police Contact (DEMO)'),
      content: SizedBox(
        width: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact: Police — Emergency Services (sample)'),
            const SizedBox(height: 6),
            if (phrase != null) ...[
              Text('Voice command heard: “$phrase”'),
              const SizedBox(height: 6),
            ],
            const Text('Location that would be shared: Highway A1, Km 120.5 (sample)'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.redTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Simulation only — no emergency call has been made.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
