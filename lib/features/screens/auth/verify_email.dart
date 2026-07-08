import "package:flutter/material.dart";
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
                  child: Image.asset('assets/6th.png', width: 150, height: 150),
                ),
                Center(
                  child: Text(
                    'Vérifie ton email',
                    style: AppStyles.bigtextstyle,
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
                InputField(
                  label: 'Adresse e-mail',
                  hint: 'Entrez votre adresse e-mail',
                  controller: emailController,
                ),
                SizedBox(height: 24),
                Button(
                  text: 'Ouvrir l\'appli',
                  onPressed: () {
                    // routes to home page
                    final email = emailController.text.trim();
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
        ),
      ),
    );
  }
}
