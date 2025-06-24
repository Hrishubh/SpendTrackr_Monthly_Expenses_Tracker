import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SpendTrackr/common/color_extension.dart';
import 'package:SpendTrackr/view/login/welcome_view.dart';
import 'package:SpendTrackr/view/main_tab/main_tab_view.dart';
import 'package:SpendTrackr/services/firebase_service.dart';
import 'package:SpendTrackr/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'SpendTrackr',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Inter",
          colorScheme: ColorScheme.fromSeed(
            seedColor: TColor.primary,
            background: TColor.gray80,
            primary: TColor.primary,
            primaryContainer: TColor.gray60,
            secondary: TColor.secondary,
          ),
          useMaterial3: false,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking auth state
        if (authProvider.isLoading) {
          return Scaffold(
            backgroundColor: TColor.gray,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/app_logo.png",
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(TColor.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show main app if authenticated, otherwise show welcome screen
        if (authProvider.isAuthenticated) {
          return const MainTabView();
        } else {
          return const WelcomeView();
        }
      },
    );
  }
}
