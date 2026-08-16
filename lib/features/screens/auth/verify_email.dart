import "package:flutter/material.dart";
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../profile/widgets/AppBackground.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyEmail extends StatefulWidget {
  final String email;
  final OtpType otpType;
  final String title;
  final String subtitle;
  final Widget nextScreen;
  const VerifyEmail({
    super.key,
    required this.email,
    required this.otpType,
    required this.title,
    required this.subtitle,
    required this.nextScreen,
  });

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
  
}

class _VerifyEmailState extends State<VerifyEmail> {
  final List<TextEditingController> _controllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  final TextEditingController emailController = TextEditingController();

  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }

    for (var f in _focusNodes) {
      f.dispose();
    }

    emailController.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> verifyCode() async {
    if (_code.length != 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Entrez le code complet")));
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final response = await supabase.auth.verifyOTP(
        type: widget.otpType,
        email: widget.email,
        token: _code,
      );
      if (response.session != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.nextScreen),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Code invalide, réessayez')));
    } finally {
      if (mounted)
        setState(() {
          _isVerifying = false;
        });
    }
  }

  Future<void> resendCode() async {
    setState(() {
      _isResending = true;
    });
    try {
      supabase.auth.resend(
        type: widget.otpType == OtpType.signup
            ? OtpType.signup
            : OtpType.recovery,
        email: widget.email,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Code renvoyé")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted)
        setState(() {
          _isResending = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
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
                    widget.title,
                    style: AppStyles.bigtextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    widget.subtitle,
                    style: AppStyles.smalltextstyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 4),
                Center(
                  child: Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dotColor,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(8, (index) {
                    return SizedBox(
                      width: 45,
                      height: 55,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.backgroundlightColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.dotColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 7) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (index == 7 && value.isNotEmpty) {
                            verifyCode();
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dotColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isVerifying
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: SpinKitDoubleBounce(
                              color: Colors.white,
                              size: 50.0,
                            ),
                          )
                        : Text(
                            "Vérifier",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
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
                      onPressed: _isResending ? null : resendCode,
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
