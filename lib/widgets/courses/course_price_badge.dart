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

    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width > 600;

    final double fontSize =
        isSmall ? (isTablet ? 11 : 10) : (isTablet ? 14 : 12);

    final double horizontalPadding =
        isSmall ? (isTablet ? 10 : 8) : (isTablet ? 14 : 12);

    final double verticalPadding =
        isSmall ? (isTablet ? 5 : 4) : (isTablet ? 8 : 6);

    final double borderRadius =
        isSmall ? (isTablet ? 14 : 12) : (isTablet ? 18 : 16);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: isFree ? Colors.green : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        isFree ? 'GRATUIT' : '${price.toInt()} $currency',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
