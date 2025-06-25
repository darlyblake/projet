/// Classe personnalisée d'exception pour une meilleure gestion des erreurs
class AppException implements Exception {
  /// Message d'erreur à afficher ou à logger
  final String message;

  /// Code d'erreur facultatif (HTTP, type d'erreur, etc.)
  final String? code;

  /// Constructeur principal
  AppException(this.message, {this.code});

  /// Affiche uniquement le message lorsqu'on imprime l'erreur
  @override
  String toString() => message;
}
