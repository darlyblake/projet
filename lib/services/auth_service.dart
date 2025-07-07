import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:edustore/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Instance partagée

  /// 🔹 Récupère l'utilisateur actuellement connecté
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.exists ? UserModel.fromFirestore(doc) : null;
  }

  /// 🔹 Connexion classique email + mot de passe
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc =
          await _firestore.collection('users').doc(credential.user!.uid).get();
      if (!doc.exists) throw Exception('Profil utilisateur non trouvé');

      return UserModel.fromFirestore(doc);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  /// 🔹 Inscription d'un nouvel utilisateur
  Future<UserModel> register(
    String name,
    String email,
    String password,
    UserRole role,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(name);

      final user = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        role: role,
        profileImage: null,
        joinDate: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toFirestore());
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthError(e));
    }
  }

  /// 🔹 Connexion Google pour mobile/desktop
  Future<UserModel> signInWithGoogle(UserRole role) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception("Connexion Google annulée");

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      return await _createOrGetUser(user, role);
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Connexion Web (avec renderButton)
  Future<UserModel> signInWithGoogleWeb(String idToken, UserRole role) async {
    try {
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      return await _createOrGetUser(user, role);
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Déconnexion
  Future<void> logout() async {
    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Ignore silently for non-Google signed users
      }
    }
    await _auth.signOut();
  }

  /// 🔹 Crée ou récupère le profil utilisateur
  Future<UserModel> _createOrGetUser(User user, UserRole role) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      final newUser = UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        role: role,
        profileImage: user.photoURL,
        joinDate: DateTime.now(),
      );
      await userDoc.set(newUser.toFirestore());
      return newUser;
    } else {
      final existingUser = UserModel.fromFirestore(snapshot);
      if (existingUser.role != role.name) {
        throw FirebaseAuthException(
          code: "role-mismatch",
          message: "Ce compte n'est pas associé à ce rôle.",
        );
      }
      return existingUser;
    }
  }

  /// 🔹 Gestion d'erreurs
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email non trouvé';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Email déjà utilisé';
      case 'role-mismatch':
        return 'Ce compte est déjà associé à un autre rôle';
      default:
        return 'Erreur d\'authentification (${e.code})';
    }
  }
}
