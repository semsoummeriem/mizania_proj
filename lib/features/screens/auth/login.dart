import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';

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
      body: AppBackground(child:
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('assets/4th.png', width: 150, height: 150)),
              Center(
                child: Text(
                  'Connexion',
                  style : AppStyles.bigtextstyle,
                ),
              ),
              Center(
                child: Text(
                  'Contents de vous revoir!',
                  style: AppStyles.smalltextstyle,
                ),
              ),
              SizedBox(height: 24),
              InputField(label: 'Adresse e-mail', hint: 'Entrez votre adresse e-mail'),
              SizedBox(height: 24),
              InputField(label: 'Mot de passe', hint: 'Entrez votre mot de passe'),
              SizedBox(height: 24),
            ],
          ),
        )
      ),
    );
  }
}