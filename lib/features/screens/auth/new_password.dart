import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import '../../../core/widgets/input_fields.dart';
import '../../../core/widgets/button.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                Center(
                  child: Text(
                    'Nouveau mot de passe',
                    style: AppStyles.bigtextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'Créer un nouveau mot de passe sécurisé.',
                    style: AppStyles.smalltextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                InputField(
                  label: 'Nouveau mot de passe',
                  hint: 'Entrez votre nouveau mot de passe',
                  isPassword: true,
                  controller: passwordController,
                ),
                SizedBox(height: 24),
                InputField(
                  label: 'Confirmer',
                  hint: 'Confirmez votre nouveau mot de passe',
                  isPassword: true,
                  controller: confirmPasswordController,
                ),
                SizedBox(height: 24),
                Button(
                  text: 'Modifier le mot de passe',
                  onPressed: () async {
                    // routes to home page
                    final password = passwordController.text;
                    final confirm = confirmPasswordController.text;

                    if (password.isEmpty || confirm.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Merci de remplir tous les champs'),
                        ),
                      );
                      return;
                    }
                    try {
                      await supabase.auth.updateUser(
                        UserAttributes(password: password),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mot de passe modifié avec succès'),
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                    }
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
