import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';
import 'package:mizania_proj/features/screens/auth/verify_email.dart';
import 'new_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
                  controller: emailController,
                ),
                SizedBox(height: 24),
                Button(
                  text: 'Envoyer le lien',
                  onPressed: () async {
                    final email = emailController.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Merci d\'entrer votre email')),
                      );
                      return;
                    }
                    try {
                      await supabase.auth.resetPasswordForEmail(email);

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyEmail(
                              email: email,
                              otpType: OtpType.recovery,
                              title: 'Code de réinitialisation',
                              subtitle: 'Entrez le code envoyé à',
                              nextScreen: const NewPassword(),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                    }
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
