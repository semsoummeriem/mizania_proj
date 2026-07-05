import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Génère un PDF récapitulatif des informations du profil et ouvre la boîte
/// de dialogue d'impression/enregistrement (fonctionne sur Windows, Web, Android, iOS
/// grâce au package `printing` - pas besoin de gérer les chemins de fichiers nous-mêmes).
Future<void> exportProfilePdf({
  required String name,
  required String email,
  required String expensesCount,
  required String monthsTracked,
  required String monthlyIncomeFormatted,
  required String currencyLabel,
  required String appearanceLabel,
  required String notificationsLabel,
  required String passwordLastUpdateLabel,
}) async {
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      build: (context) => pw.Padding(
        padding: const pw.EdgeInsets.all(24),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Mizania — Export du profil',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text(name, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text(email),
            pw.SizedBox(height: 24),

            pw.Text('Statistiques',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Bullet(text: 'Dépenses enregistrées : $expensesCount'),
            pw.Bullet(text: 'Mois suivis : $monthsTracked'),
            pw.Bullet(text: 'Revenu mensuel : $monthlyIncomeFormatted'),
            pw.SizedBox(height: 24),

            pw.Text('Compte', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Bullet(text: 'Nom : $name'),
            pw.Bullet(text: 'Email : $email'),
            pw.Bullet(text: 'Mot de passe : $passwordLastUpdateLabel'),
            pw.Bullet(text: 'Revenu mensuel : $monthlyIncomeFormatted'),
            pw.SizedBox(height: 24),

            pw.Text('Préférences',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Bullet(text: 'Devise : $currencyLabel'),
            pw.Bullet(text: 'Apparence : $appearanceLabel'),
            pw.Bullet(text: 'Notifications : $notificationsLabel'),
          ],
        ),
      ),
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => doc.save());
}