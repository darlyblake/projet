import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/cart_provider.dart';

import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';
import 'firebase_options.dart'; // Généré par flutterfire configure
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // Pour setUrlStrategy

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Configuration de l’URL (web uniquement)
  if (kIsWeb) {
    setUrlStrategy(
        PathUrlStrategy()); // ⚠️ Doit être appelé ici, une seule fois
  }

  // Chargement des variables d’environnement
  await dotenv.load(fileName: "assets/env.example");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("✅ Connexion Firebase réussie");
  } catch (e) {
    debugPrint("❌ Erreur lors de la connexion à Firebase : $e");
  }

  runApp(const EduStoreApp());
}

class EduStoreApp extends StatelessWidget {
  const EduStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'EduStore',
        theme: AppTheme.lightTheme,
        home: const FirebaseCheckWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class FirebaseCheckWrapper extends StatefulWidget {
  const FirebaseCheckWrapper({super.key});

  @override
  State<FirebaseCheckWrapper> createState() => _FirebaseCheckWrapperState();
}

class _FirebaseCheckWrapperState extends State<FirebaseCheckWrapper> {
  @override
  void initState() {
    super.initState();

    // 🔥 On ne met plus initGoogleSignInButton ici — il est dans main

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Connexion Firebase réussie'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomeScreen();
  }
}
