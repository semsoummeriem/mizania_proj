import 'package:flutter/material.dart';
import 'app_state.dart';

/// Rend l'AppState disponible à tous ses widgets descendants.
///
/// UTILISATION : depuis n'importe quelle page en dessous de ce widget dans
/// l'arbre, on peut faire `AppStateScope.of(context)` pour lire ou modifier
/// l'état partagé (nom, revenu, devise, etc.).
///
/// C'est un `InheritedNotifier` : Flutter reconstruit automatiquement tout
/// widget qui a appelé `.of(context)` dès que l'AppState appelle
/// `notifyListeners()`, sans qu'on ait besoin de gérer ça nous-mêmes.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'Aucun AppStateScope trouvé au-dessus de ce widget.');
    return scope!.notifier!;
  }
}