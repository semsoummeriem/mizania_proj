import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/5th.png', width: 150, height: 150),
                ),
                Center(
                  child: Text(
                    'Mot de passe oublié?',
                    style: AppStyles.bigtextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'Entre ton email pour  recevoir un lien de réinitialisation',
                    style: AppStyles.smalltextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                InputField(
                  label: 'Adresse e-mail',
                  hint: 'Entrez votre adresse e-mail',
                ),
                SizedBox(height: 24),
                Button(
                  text: 'Envoyer le lien',
                  onPressed: () {
                    // routes to home page
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
