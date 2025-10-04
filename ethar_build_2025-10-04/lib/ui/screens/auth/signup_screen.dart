import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _agency = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _phone.dispose(); _password.dispose(); _agency.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState!.validate()) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: [
            _PillField(
              label: 'Full Name',
              child: TextFormField(
                controller: _name,
                decoration: const InputDecoration(hintText: 'Ahmad'), // placeholder
                validator: _req,
              ),
            ),
            const SizedBox(height: 12),
            _PillField(
              label: 'Email Address',
              child: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'ahmad@gmail.com'),
                validator: _emailV,
              ),
            ),
            const SizedBox(height: 12),
            _PillField(
              label: 'Phone Number',
              child: TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '966 5X XXX XXXX'),
                validator: _req,
              ),
            ),
            const SizedBox(height: 12),
            _PillField(
              label: 'Password',
              child: TextFormField(
                controller: _password,
                obscureText: _obscure1,
                decoration: InputDecoration(
                  hintText: '********',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
            ),
            const SizedBox(height: 12),
            _PillField(
              label: 'Agency Code',
              child: TextFormField(
                controller: _agency,
                obscureText: _obscure2,
                decoration: InputDecoration(
                  hintText: '********',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                  ),
                ),
                validator: _req,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Sign Up', onPressed: _submit, icon: Icons.person_add_alt),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
  String? _emailV(String? v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null;
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

