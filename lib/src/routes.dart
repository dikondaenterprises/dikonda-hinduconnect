import 'package:flutter/material.dart';
import 'ui/auth/sign_in_page.dart';
import 'ui/auth/sign_up_page.dart';
import 'ui/auth/forgot_password_page.dart';
import 'ui/auth/profile_page.dart';
import 'ui/search/search_page.dart';
import 'ui/search/result_page.dart';
import 'ui/home/home_page.dart';
import 'model/content_type.dart'; // <-- Update this path based on your structure

final Map<String, WidgetBuilder> appRoutes = {
  '/signin': (_) => const SignInPage(),
  '/signup': (_) => const SignUpPage(),
  '/forgot-password': (_) => const ForgotPasswordPage(),
  '/profile': (_) => const ProfilePage(),
  '/search': (_) => const SearchPage(),
  '/home': (_) => const HomePage(),

  '/result': (ctx) {
    final args = ModalRoute.of(ctx)?.settings.arguments as Map<String, dynamic>?;

    if (args == null ||
        args['id'] == null ||
        args['title'] == null ||
        args['content'] == null ||
        args['type'] == null) {
      return const Scaffold(
        body: Center(child: Text('Missing result page arguments')),
      );
    }

    return ResultPage(
      id: args['id'] as String,
      title: args['title'] as String,
      content: args['content'] as String,
      type: args['type'] as ContentType,
    );
  },
};
