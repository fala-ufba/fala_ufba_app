import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LoadingWidget({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/animations/loading.json',
          width: width ?? 150,
          height: height ?? 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text('Carregando...', style: Theme.of(context).textTheme.displayMedium),
      ],
    );
  }
}
