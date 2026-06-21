import 'package:flutter/material.dart';

class AppEmptyStateWidget extends StatelessWidget {
  final String title;

  const AppEmptyStateWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_clear_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
