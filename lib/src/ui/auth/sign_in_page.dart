import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app/providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _trySignIn() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { _loading = true; _error = null; });
    final auth = context.read<AuthProvider>();
    final msg = await auth.signIn(email: _email, password: _password);
    setState(() { _loading = false; });
    if (msg != null) {
      setState(() { _error = msg; });
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _email = v!.trim(),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _password = v!,
                validator: (v) {
                  if (v == null || v.length < 6) return '6+ characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _trySignIn, child: const Text('Sign In')),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text('Don’t have an account? Sign Up'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                child: const Text('Forgot Password?'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
