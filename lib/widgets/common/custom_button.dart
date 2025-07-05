import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;

  // Responsivité : taille personnalisée optionnelle
  final double? height;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
    this.height,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth > 600;

    final double btnHeight = height ?? (isTabletOrDesktop ? 56 : 48);
    final double txtFontSize = fontSize ?? (isTabletOrDesktop ? 18 : 16);
    final double horizontalPadding = isTabletOrDesktop ? 32 : 24;
    final double verticalPadding = (btnHeight - txtFontSize) / 2;

    final Widget child = _buildChild(txtFontSize);

    final ButtonStyle style = (isOutlined
        ? OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ));

    return SizedBox(
      height: btnHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: style,
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: style,
              child: child,
            ),
    );
  }

  Widget _buildChild(double fontSize) {
    if (isLoading) {
      return SizedBox(
        height: fontSize,
        width: fontSize,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize * 1.2),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
