// features/auth/presentation/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipesantren/firebase_services.dart';
import 'package:sipesantren/crypt.dart';
import 'login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState(); // Corrected class name
}

class _RegisterPageState extends ConsumerState<RegisterPage> { // Corrected class name
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Ustadz';
  final FirebaseServices db = FirebaseServices();
  bool loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use theme background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Header
              Column(
                children: [
                  Icon(Icons.mosque, size: 80, color: Theme.of(context).colorScheme.primary), // Use primary color
                  const SizedBox(height: 20),
                  Text(
                    'Daftar Akun Baru', // Title for Register Page
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan lengkapi data Anda', // Subtitle for Register Page
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Register Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15), // Softer corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3), // Softer shadow
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Role Selection (Dropdown)
                      _RegisterInputCard(
                        labelText: 'Peran',
                        icon: Icons.category,
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole, // Ensure initial value is handled
                          decoration: InputDecoration(
                            border: InputBorder.none, // Remove border, handled by parent Container
                            contentPadding: EdgeInsets.zero, // Remove default padding
                            labelText: 'Peran',
                            prefixIcon: Icon(Icons.category, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                            DropdownMenuItem(value: 'Ustadz', child: Text('Ustadz/Wali Kelas')),
                            DropdownMenuItem(value: 'Wali', child: Text('Wali Santri')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Peran harus dipilih';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama Field
                      _RegisterInputCard(
                        controller: _nameController,
                        labelText: 'Nama Lengkap',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      _RegisterInputCard(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email harus diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      _RegisterInputCard(
                        controller: _passwordController,
                        labelText: 'Kata Sandi',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi harus diisi';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loading ? null : () async { // Disable button when loading
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              bool userCreated = await db.createUser(
                                _nameController.text,
                                _emailController.text,
                                PasswordHandler.hashPassword(_passwordController.text, PasswordHandler.generateSalt()),
                                _selectedRole
                              );

                              if (mounted) {
                                setState(() {
                                  loading = false;
                                });
                                if (userCreated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registrasi berhasil!')), // Translated
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(fromSuccessRegistration: true),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Registrasi gagal. Email mungkin sudah terdaftar.')), // Translated
                                  );
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary, // Use primary color
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Consistent with admin buttons
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white), // White loading indicator
                                )
                              : const Text('Daftar'), // Translated
                        ),
                      ),
                      const SizedBox(height: 20), // Spacing
                      SizedBox(
                        width: double.infinity,
                        child: TextButton( // Changed to TextButton for a flatter look
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary, // Primary color for link
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Sudah punya akun? Masuk disini.'), // Translated
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for consistent input field styling
class _RegisterInputCard extends StatelessWidget {
  final TextEditingController? controller; // Made nullable for dropdown case
  final String labelText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? child; // For dropdown

  const _RegisterInputCard({
    this.controller,
    required this.labelText,
    required this.icon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.child, // For dropdown
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child ?? TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none, // Remove border from TextFormField itself
          contentPadding: EdgeInsets.zero, // Remove default padding
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
          prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
        ),
        validator: validator,
      ),
    );
  }
}
