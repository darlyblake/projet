import 'package:flutter/material.dart';

class RoleSelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  // Paramètres optionnels
  final double? buttonHeight;
  final double? buttonFontSize;

  const RoleSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonColor,
    required this.onPressed,
    this.buttonHeight,
    this.buttonFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    final double responsiveFontSize = isTablet ? 22.0 : 18.0;
    final double responsiveSubFontSize = isTablet ? 16.0 : 14.0;
    final double responsiveButtonHeight =
        buttonHeight ?? (isTablet ? 56.0 : 48.0);
    final double responsiveButtonFontSize =
        buttonFontSize ?? (isTablet ? 18.0 : 16.0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: isTablet ? 64 : 48, color: buttonColor),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: responsiveFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: responsiveSubFontSize),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: responsiveButtonHeight,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  textStyle: TextStyle(fontSize: responsiveButtonFontSize),
                ),
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
