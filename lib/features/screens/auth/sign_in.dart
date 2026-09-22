import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:mizania_proj/features/screens/main_navigation_screen.dart';
import "package:mizania_proj/features/screens/auth/login.dart";
import 'package:mizania_proj/core/widgets/google_signin_button.dart';
import 'package:mizania_proj/core/state/app_state_scope.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("S'inscrire")),
      backgroundColor: AppColors.scaffoldBg(context),
      body: AppBackground(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Inscription', style: AppStyles.bigtextstyle),
                  ),
                  Center(
                    child: Text(
                      'Crée ton compte.',
                      style: AppStyles.smalltextstyle,
                    ),
                  ),
                  SizedBox(height: 24),
                  InputField(
                    label: 'Nom',
                    hint: 'Entrez votre nom',
                    controller: nameController,
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
                  InputField(
                    label: 'Confirmer',
                    hint: 'Confirmez votre mot de passe',
                    isPassword: true,
                    controller: confirmPasswordController,
                  ),
                  SizedBox(height: 24),
                  Button(
                    text: 'S\'inscrire',
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text;
                      final confirmedPass = confirmPasswordController.text;

                      if (email.isEmpty || name.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Merci de remplir tous les champs.'),
                          ),
                        );
                        return;
                      }

                      if (confirmedPass != password) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Les mots de passe ne correspondent pas.',
                            ),
                          ),
                        );
                        return;
                      }

                      try {
                        final response = await supabase.auth.signUp(
                          email: email,
                          password: password,
                          data: {'name': name},
                        );
                        if (response.user != null) {
                          if (context.mounted) {
                            final appState = AppStateScope.of(context);
                            appState.reset();
                            await appState.loadProfile();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainNavigationScreen(),
                                ),
                              );
                            }
                          }
                        }
                      } on AuthException catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                      }
                    },
                  ),
                  SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Vous avez déjà un compte?',
                        style: AppStyles.smalltextstyle,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child: Text(
                          'Se connecter',
                          style: AppStyles.LinkbuttonTextStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  const SigninGoogleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
