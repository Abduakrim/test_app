import 'package:flutter/material.dart';
import 'package:test_app/src/core/widgets/shimmer_item.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) => const ShimmerItem(),
    );
  }
}
