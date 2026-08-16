import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';
import '../../../core/services/profile_service.dart';

/// Page "Changer le mot de passe".
/// On ne reçoit et on ne renvoie aucune valeur sensible : on renvoie juste
/// `true` avec Navigator.pop(context, true) si tout s'est bien passé,
/// pour que la page précédente puisse afficher un message de succès.
class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ProfileService _profileService = ProfileService();

  String? _errorText;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // On écoute les changements du nouveau mot de passe pour mettre à jour
    // la barre de force en temps réel.
    _newPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Calcule un score de force entre 0 et 4 selon quelques critères simples.
  int get _strengthScore {
    final password = _newPasswordController.text;
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~%^()_\-+=]').hasMatch(password)) score++;
    return score;
  }

  String get _strengthLabel {
    final password = _newPasswordController.text;
    if (password.isEmpty) return '';
    switch (_strengthScore) {
      case 0:
      case 1:
        return 'Faible — essaie un mot de passe plus long.';
      case 2:
        return 'Moyen — ajoute des chiffres pour le renforcer.';
      case 3:
        return 'Bon — ajoute un symbole pour le renforcer.';
      default:
        return 'Fort — bien joué !';
    }
  }

  Future<void> _updatePassword() async {
    final current = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPassword.isEmpty || confirm.isEmpty) {
      setState(() => _errorText = 'Merci de remplir tous les champs.');
      return;
    }
    if (newPassword.length < 6) {
      setState(() => _errorText = 'Le nouveau mot de passe est trop court (6 caractères min).');
      return;
    }
    if (newPassword != confirm) {
      setState(() => _errorText = 'Les mots de passe ne correspondent pas.');
      return;
    }

    setState(() {
      _errorText = null;
      _isSubmitting = true;
    });

    try {
      await _profileService.changePassword(
        oldPassword: current,
        newPassword: newPassword,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = e.toString().replaceFirst('Exception: ', '');
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mot de passe actuel', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildInputField(_currentPasswordController),
                  const SizedBox(height: 20),
                  const Text('Nouveau mot de passe', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildInputField(_newPasswordController),
                  const SizedBox(height: 10),
                  _buildStrengthBar(),
                  if (_strengthLabel.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(_strengthLabel, style: AppStyles.strengthLabelStyle),
                  ],
                  const SizedBox(height: 20),
                  const Text('Confirmer', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildInputField(_confirmPasswordController),
                  if (_errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(_errorText!, style: AppStyles.errorTextStyle),
                  ],
                  const SizedBox(height: 28),
                  _buildUpdateButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      color: AppColors.darkmauveColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          ),
          const SizedBox(width: 4),
          const Text('Changer le mot de passe', style: AppStyles.editAppBarTitleStyle),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkmauveColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: AppStyles.inputTextStyle,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Barre de force en 4 segments, remplis en vert selon le score
  Widget _buildStrengthBar() {
    return Row(
      children: List.generate(4, (index) {
        final isFilled = index < _strengthScore;
        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
            decoration: BoxDecoration(
              color: isFilled ? AppColors.greenColor : AppColors.dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _updatePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkmauveColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.whiteColor),
              )
            : const Text('Mettre à jour', style: AppStyles.buttonTextStyle),
      ),
    );
  }
}