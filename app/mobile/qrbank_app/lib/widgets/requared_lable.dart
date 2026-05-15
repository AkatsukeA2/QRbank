import 'package:flutter/material.dart';

class RequaredLable extends StatelessWidget {
  
  final String text;

  const RequaredLable({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
  
    return Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3D2B7A),
                    ),
                  ),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  )
                ],
              );
  }
}