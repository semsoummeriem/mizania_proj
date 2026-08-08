import "package:flutter/material.dart";
import "package:mizania_proj/core/services/supabase_client.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class SigninGoogleButton extends StatefulWidget {
  const SigninGoogleButton({super.key});

  @override
  State<SigninGoogleButton> createState() => _SigninGoogleButtonState();
}

class _SigninGoogleButtonState extends State<SigninGoogleButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          try {
            await supabase.auth.signInWithOAuth(
              OAuthProvider.google,
              redirectTo: 'mizania://login-callback/',
            );
          } catch (e) {
            debugPrint('Error signing in with Google: $e');
          }
        },
        icon: Icon(Icons.g_mobiledata, size: 28),
        label: Text('Sign in with Google'),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          textStyle: TextStyle(fontSize: 16),
          side: BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
