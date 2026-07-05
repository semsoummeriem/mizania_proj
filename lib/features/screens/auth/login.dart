import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: Center(
        child:Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/4th.png', width: 150, height: 150),
            Text(
              'Connexion',
              style : AppStyles.bigtextstyle,
            ),
            Text(
              'Contents de vous revoir!',
              style: AppStyles.smalltextstyle,
            ),
            SizedBox(height: 10),
            Text(
              'Email',
              style: AppStyles.labelStyle,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez votre email',
              ),
            ),
          ],
        ),
        )
    );
  }
}