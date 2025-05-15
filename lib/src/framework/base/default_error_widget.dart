import 'package:flutter/material.dart';

import '../utils/color_util.dart';

class DefaultErrorWidget extends StatelessWidget {
  final String errorMessage;
  final String? refName;
  final Object? errorDetails;

  const DefaultErrorWidget({
    super.key,
    required this.errorMessage,
    this.refName,
    this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorUtil.fromHexString('#F9E6EB'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 18),
              const SizedBox(height: 16),
              Container(
                width: 10,
              ),
              Text(
                'Error Rendering Widget ${refName ?? ''}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          if (errorDetails != null) ...[
            const SizedBox(height: 16),
            Text(
              'Details: $errorDetails',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
