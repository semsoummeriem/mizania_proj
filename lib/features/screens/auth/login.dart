import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

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
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Hroutes to forgot password page
                    },
                    child: Text(
                      'Mot de passe oublié?',
                      style: AppStyles.LinkbuttonTextStyle,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Button(
                  text: 'Se connecter',
                  onPressed: () {
                    // routes to home page
                  },
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous n\'avez pas de compte?',
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
                        'S\'inscrire',
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