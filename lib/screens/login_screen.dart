import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              // --- BRANDING SECTION ---
              Icon(Icons.shield_rounded, size: 85, color: Colors.blue[800]),
              const SizedBox(height: 15),
              Text(
                "CampusGuard",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue[900], letterSpacing: 1.2),
              ),
              Text("Empowering Student Safety", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              
              const SizedBox(height: 50),

              // --- INPUT FIELDS ---
              _buildTextField(
                controller: _emailController,
                hint: "Email Address",
                icon: Icons.alternate_email,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock_person_outlined,
                isPassword: true,
              ),
              
              const SizedBox(height: 35),

              // --- SUBMIT BUTTON ---
              authVm.isLoading 
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      onPressed: () async {
                        bool success = _isSignUp
                            ? await authVm.signUp(_emailController.text, _passwordController.text)
                            : await authVm.signIn(_emailController.text, _passwordController.text);
                        
                        if (success && context.mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                        } else if (authVm.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(backgroundColor: Colors.red[700], content: Text(authVm.errorMessage!))
                          );
                        }
                      },
                      child: Text(
                        _isSignUp ? "CREATE ACCOUNT" : "SIGN IN", 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
              
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp ? "Already have an account? Sign In" : "New student? Create an account", 
                  style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[800]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}