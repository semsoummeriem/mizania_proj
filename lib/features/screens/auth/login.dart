import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';
import 'package:mizania_proj/features/screens/auth/sign_in.dart';
import 'package:mizania_proj/features/screens/main_navigation_screen.dart';
import 'forgot_password.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import '../../../core/state/app_state_scope.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                  Center(
                    child: Image.asset(
                      'assets/4th.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Center(
                    child: Text('Connexion', style: AppStyles.bigtextstyle),
                  ),
                  Center(
                    child: Text(
                      'Contents de vous revoir!',
                      style: AppStyles.smalltextstyle,
                    ),
                  ),
                  SizedBox(height: 24),
                  InputField(
                    label: 'Adresse e-mail',
                    hint: 'Entrez votre adresse e-mail',
                    controller: emailController,
                  ),
                  SizedBox(height: 24),
                  InputField(
                    label: 'Mot de passe',
                    hint: 'Entrez votre mot de passe',
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Hroutes to forgot password page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
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
                    onPressed: () async {
                      // routes to home page
                      final email = emailController.text.trim();
                      final password = passwordController.text;
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Merci de remplir vos données.'),
                          ),
                        );
                        return;
                      }

                      try {
                        final response = await supabase.auth.signInWithPassword(
                          email: email,
                          password: password,
                        );
                        if (response.user != null) {
  await AppStateScope.of(context).loadProfile();
  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
      ),
    );
  }
}
                      } on AuthException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      }
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
                          //Onboarding()._timer.cancel(); // Cancel the timer when navigating to the sign-up page
                          // routes to sign up page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
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
          ),
        ),
      ),
    );
  }
}
