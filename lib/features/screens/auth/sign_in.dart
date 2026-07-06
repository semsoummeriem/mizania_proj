import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: AppBackground(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('Inscription', style: AppStyles.bigtextstyle)),
                  Center(
                    child: Text(
                      'Crée ton compte.',
                      style: AppStyles.smalltextstyle,
                    ),
                  ),
                  SizedBox(height: 24),
                  InputField(label: 'Nom', hint: 'Entrez votre nom'),
                  SizedBox(height: 24),
                  InputField(
                    label: 'Adresse e-mail',
                    hint: 'Entrez votre adresse e-mail',
                  ),
                  SizedBox(height: 24),
                  InputField(
                    label: 'Mot de passe',
                    hint: 'Entrez votre mot de passe',
                  ),
                  SizedBox(height: 24),
                  InputField(
                    label: 'Confirmer',
                    hint: 'confirmez votre mot de passe',
                  ),
                  SizedBox(height: 24),
                  Button(
                    text: 'S\'inscrire',
                    onPressed: () {
                      // routes to home page
                    },
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
