import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const ActionButton(
      {required this.icon, required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              route,
              // MaterialPageRoute(builder: (_) => const LoginScreen()), --- IGNORE ---
            );
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDE8F8), width: 1.5),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF3D2B7A)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF3D2B7A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
