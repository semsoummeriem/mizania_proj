import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';

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
                    onPressed: () {
                      // routes to home page
                      final name = nameController.text;
                      final email = emailController.text.trim();
                      final password = passwordController.text;
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
