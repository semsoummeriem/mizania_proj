import "package:flutter/material.dart";
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: AppBackground(child:
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset('assets/6th.png', width: 150, height: 150)),
                Center(
                  child: Text(
                    'Vérifie ton email',
                    style : AppStyles.bigtextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'On t’a envoyé un mail à you@exemple.com',
                    style: AppStyles.smalltextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                InputField(label: 'Adresse e-mail', hint: 'Entrez votre adresse e-mail'),
                SizedBox(height: 24),
                Button(
                  text: 'Ouvrir l\'appli',
                  onPressed: () {
                    // routes to home page
                  },
                ),
                SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pas reçu?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.smalltextColor,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // routes to sign up page
                    },
                    child: Text(
                      'Renvoyer',
                      style: AppStyles.LinkbuttonTextStyle,
                    ),
                  ),
                ],
              ),
              ],
            ),
          ),
        )
      ),
    );
    }
}