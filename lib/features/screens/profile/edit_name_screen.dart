import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/styles.dart';

/// Page "Modifier le nom".
/// Reçoit le nom actuel via [currentName].
/// Quand l'utilisateur clique sur "Enregistrer", on renvoie le nouveau nom
/// à la page précédente avec Navigator.pop(context, nouveauNom).
/// C'est la page ProfileScreen qui décide ensuite quoi faire de ce nouveau nom
/// (elle met à jour son propre état, donc le header ET la section "compte"
/// changent automatiquement puisqu'ils lisent la même variable).
class EditNameScreen extends StatefulWidget {
  final String currentName;

  const EditNameScreen({super.key, required this.currentName});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // On pré-remplit le champ "Nouveau nom" avec le nom actuel, comme sur la maquette.
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    // On libère le controller quand la page est détruite, pour éviter les fuites mémoire.
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return; // on évite d'enregistrer un nom vide
    Navigator.pop(context, newName);
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
                  const Text('Nom actuel', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildReadonlyField(widget.currentName),
                  const SizedBox(height: 20),
                  const Text('Nouveau nom', style: AppStyles.fieldLabelStyle),
                  const SizedBox(height: 8),
                  _buildInputField(),
                  const SizedBox(height: 8),
                  const Text(
                    'Entre ton prénom et nom complet.',
                    style: AppStyles.helperTextStyle,
                  ),
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

  // ---- Barre du haut violette avec flèche retour + titre ----
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
          const Text('Modifier le nom', style: AppStyles.editAppBarTitleStyle),
        ],
      ),
    );
  }

  // ---- Champ non-modifiable affichant le nom actuel ----
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

  // ---- Champ éditable pour saisir le nouveau nom ----
  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkmauveColor, width: 1.5),
      ),
      child: TextField(
        controller: _nameController,
        style: AppStyles.inputTextStyle,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // ---- Bouton "Enregistrer" ----
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveName,
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