import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edustore/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Convertit les données Firestore + Firebase User en un objet UserModel
  Future<UserModel> _userFromDocAndFirebaseUser(
    User user,
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data();
    if (data == null) {
      throw Exception('Données Firestore vides');
    }

    final roleStr = data['role'] as String? ?? 'student';
    final role = roleStr == 'teacher' ? UserRole.teacher : UserRole.student;

    return UserModel(
      id: data['id'] ?? user.uid.hashCode,
      name: user.displayName ?? data['name'] ?? 'Utilisateur Firebase',
      email: user.email ?? data['email'] ?? '',
      role: role,
      avatar: data['avatar'],
      joinDate: data['joinDate'] != null
          ? DateTime.tryParse(data['joinDate']) ?? DateTime.now()
          : user.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// Connexion de l'utilisateur
  Future<UserModel> login(String email, String password, UserRole role) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Utilisateur non trouvé');

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) throw Exception('Données utilisateur non trouvées');

      return _userFromDocAndFirebaseUser(user, doc);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Erreur lors de la connexion');
    }
  }

  /// Enregistrement d’un nouvel utilisateur
  Future<UserModel> register(
    String name,
    String email,
    String password,
    UserRole role,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      await user.updateDisplayName(name);
      await user.reload();

      final userDocRef = _firestore.collection('users').doc(user.uid);

      final userModelData = {
        'id': user.uid.hashCode,
        'name': name,
        'email': email,
        'role': role == UserRole.teacher ? 'teacher' : 'student',
        'avatar': null,
        'joinDate': DateTime.now().toIso8601String(),
      };

      await userDocRef.set(userModelData);

      final updatedUser = _firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw Exception('Erreur de mise à jour du profil');
      }

      final doc = await userDocRef.get();
      return _userFromDocAndFirebaseUser(updatedUser, doc);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Erreur lors de l\'inscription');
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
