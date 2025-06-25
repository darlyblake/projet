import 'package:flutter/material.dart';

class CoursePriceBadge extends StatelessWidget {
  final double price;
  final String currency;
  final bool isSmall;

  const CoursePriceBadge({
    super.key,
    required this.price,
    required this.currency,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = price == 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: isFree ? Colors.green : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
      ),
      child: Text(
        isFree ? 'GRATUIT' : '${price.toInt()} $currency',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isSmall ? 10 : 12,
        ),
      ),
    );
  }
}
