import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_app/providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '', _confirm = '';
  bool _loading = false;
  String? _error;

  Future<void> _trySignUp() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (_password != _confirm) {
      setState(() { _error = 'Passwords must match'; });
      return;
    }
    setState(() { _loading = true; _error = null; });
    final auth = context.read<AuthProvider>();
    final msg = await auth.signUp(email: _email, password: _password);
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
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _email = v!.trim(),
                validator: (v) => (v==null||!v.contains('@'))?'Invalid':null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (v) => _password = v!,
                validator: (v) => (v==null||v.length<6)?'6+ chars':null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                onSaved: (v) => _confirm = v!,
                validator: (v) => (v==null||v.length<6)?'Confirm':null,
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _trySignUp, child: const Text('Create Account')),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
                child: const Text('Already have an account? Sign In'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
