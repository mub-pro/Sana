import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final EdgeInsetsGeometry padding;
  final Function onTap;

  CustomIconButton(
      {this.icon,
      this.color,
      this.size,
      this.padding = const EdgeInsets.all(0.0),
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          onTap: onTap,
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );
  }
}
