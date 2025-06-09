import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'routes.dart';
import 'ui/auth/sign_in_page.dart';

class DevotionalApp extends StatelessWidget {
  const DevotionalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Devotional App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const AuthGate(),
        routes: appRoutes,
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoggedIn) {
      // Load user profile
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        context.read<UserProvider>().loadUser(uid);
      }
      return const MainApp();
    } else {
      return const SignInPage();
    }
  }
}
