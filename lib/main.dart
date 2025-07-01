import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/welcome_screen.dart';
import 'utils/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/env.example");
  } catch (e) {
    debugPrint("Erreur de chargement du .env : $e");
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
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
