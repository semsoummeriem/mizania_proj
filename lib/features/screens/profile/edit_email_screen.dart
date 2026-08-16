import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

/// Page "Modifier l'email".
/// Reçoit l'email actuel via [currentEmail].
/// Si le nouvel email saisi est valide, on le renvoie à la page précédente
/// avec Navigator.pop(context, nouvelEmail). Sinon on affiche une erreur.
class EditEmailScreen extends StatefulWidget {
  final String currentEmail;

  const EditEmailScreen({super.key, required this.currentEmail});

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  late final TextEditingController _emailController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Vérification simple : contient un "@", un "." après le "@", et pas d'espace.
  bool _isValidEmail(String value) {
    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(value);
  }

  void _saveEmail() {
    final newEmail = _emailController.text.trim();

    if (newEmail.isEmpty) {
      setState(() => _errorText = 'Merci de saisir un email.');
      return;
    }
    if (!_isValidEmail(newEmail)) {
      setState(() => _errorText = 'Cet email n\'est pas valide.');
      return;
    }

    setState(() => _errorText = null);
    Navigator.pop(context, newEmail);
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
                  const Text('Email actuel', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildReadonlyField(widget.currentEmail),
                  const SizedBox(height: 20),
                  const Text('Nouvel email', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildInputField(),
                  if (_errorText != null) ...[
                    const SizedBox(height: 6),
                    Text(_errorText!, style: AppStyles.errorTextStyle),
                  ] else ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Un email de confirmation sera envoyé.',
                      style: AppStyles.helperTextStyle,
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildInfoBox(),
                  const SizedBox(height: 28),
                  _buildSaveButton(),
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
          const Text('Modifier l\'email', style: AppStyles.editAppBarTitleStyle),
        ],
      ),
    );
  }

  Widget _buildReadonlyField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(value, style: AppStyles.inputTextStyle),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkmauveColor, width: 1.5),
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: AppStyles.inputTextStyle,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // Bandeau d'information jaune, comme sur la maquette
  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.orangeLightColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.amberColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.amberColor, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Confirme ton adresse actuelle pour continuer.',
              style: AppStyles.infoBoxTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkmauveColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('Enregistrer', style: AppStyles.buttonTextStyle),
      ),
    );
  }
}