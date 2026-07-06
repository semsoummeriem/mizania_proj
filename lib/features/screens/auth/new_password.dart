import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('Nouveau mot de passe', style: AppStyles.bigtextstyle, textAlign: TextAlign.center)),
                Center(
                  child: Text(
                    'Créer un nouveau mot de passe sécurisé.',
                    style: AppStyles.smalltextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                InputField(label: 'Nouveau mot de passe', hint: 'Entrez votre nouveau mot de passe'),
                SizedBox(height: 24),
                InputField(
                  label: 'Confirmer',
                  hint: 'Confirmez votre nouveau mot de passe',
                ),
                SizedBox(height: 24),
                Button(
                  text: 'Modifier le mot de passe',
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
    );
  }
}
