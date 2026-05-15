import 'package:flutter/material.dart';

class TopText extends StatelessWidget {

  final String text;
  final String route;
  final double paddingRight;

  const TopText({Key? key, required this.text, required this.route, required this.paddingRight}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 16, right: paddingRight),
                child: GestureDetector(
                  onTap: () {
                    // TODO: navegar para login ou home
                    Navigator.of(context).pushReplacementNamed(
                      route,
                      // MaterialPageRoute(builder: (_) => const LoginScreen()), --- IGNORE ---
                    );
                  },
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7B5FC4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
  }
}