import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();   // بدون قيمة مبدئية
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  void _submit() {
    if (_form.currentState!.validate()) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: [
            _PillField(
              label: 'Email Address',
              child: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'ahmad@gmail.com', // ← placeholder رمادي
                ),
                validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
              ),
            ),
            const SizedBox(height: 12),
            _PillField(
              label: 'Password',
              child: TextFormField(
                controller: _password,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '********', // ← placeholder
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(onPressed: () {}, child: const Text('Forgot Password')),
            ),
            const SizedBox(height: 4),
            PrimaryButton(label: 'Login', onPressed: _submit, icon: Icons.login),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Divider(color: cs.outlineVariant)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Or')),
                Expanded(child: Divider(color: cs.outlineVariant)),
              ],
            ),
            const SizedBox(height: 16),
            _SocialButton(label: 'Google', assetPath: 'assets/icons/google.png', onPressed: () {}),
            const SizedBox(height: 12),
            _SocialButton(label: 'Apple', assetPath: 'assets/icons/apple.png', onPressed: () {}),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  final String label; final Widget child;
  const _PillField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 12, bottom: 6),
          child: Text(label, style: TextStyle(color: cs.onSurfaceVariant)),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label; final String assetPath; final VoidCallback onPressed;
  const _SocialButton({required this.label, required this.assetPath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          side: BorderSide(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, height: 20, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

