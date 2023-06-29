import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double progress;

  const LoadingIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 110,
        width: 110,
        child: Card(
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                '${(progress * 100).toStringAsFixed(2)} %',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
