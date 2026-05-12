import 'package:flutter/material.dart';

class TopTextCenter extends StatelessWidget {
  final String title;

  const TopTextCenter({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B3DBE),
                  ),
                ),
              );
  }
}