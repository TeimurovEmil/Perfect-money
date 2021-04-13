import 'package:flutter/material.dart';

Widget buttons(BuildContext context, String route, Color borderColor,
    IconData icon, Color iconColor) {
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, route),
    child: Container(
      height: size.height * 0.2,
      width: size.width * 0.32,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(-2, 2),
            blurRadius: 5,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 3),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 45,
      ),
    ),
  );
}
