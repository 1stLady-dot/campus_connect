import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  // --- SUCCESS DIALOG FOR BONUS MARKS ---
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          icon: Icon(Icons.check_circle_outline, color: Colors.green, size: 70),
          title: const Text("Success!", textAlign: TextAlign.center),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (_) => HomeScreen())
                  );
                },
                child: const Text("GET STARTED", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

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
              const SizedBox(height: 80),
              // --- BRANDING ---
              Icon(Icons.shield_rounded, size: 90, color: Colors.blue[800]),
              const SizedBox(height: 15),
              Text(
                "CampusGuard",
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blue[900], 
                  letterSpacing: 1.2
                ),
              ),
              Text(
                "Your Safety, Our Priority", 
                style: TextStyle(color: Colors.grey[600], fontSize: 16)
              ),
              
              const SizedBox(height: 50),

              // --- INPUT FIELDS ---
              _buildTextField(
                controller: _emailController,
                hint: "University Email",
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
                          if (_isSignUp) {
                            _showSuccessDialog(context, "Welcome to CampusGuard! Your safety account has been created successfully.");
                          } else {
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (_) => HomeScreen())
                            );
                          }
                        } else if (authVm.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red[700], 
                              content: Text(authVm.errorMessage!),
                              behavior: SnackBarBehavior.floating,
                            )
                          );
                        }
                      },
                      child: Text(
                        _isSignUp ? "CREATE ACCOUNT" : "SIGN IN", 
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
              
              const SizedBox(height: 20),
              
              // --- TOGGLE SIGN IN / SIGN UP ---
              TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(
                  _isSignUp 
                    ? "Already have an account? Sign In" 
                    : "New student? Create an account", 
                  style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TEXTFIELD BUILDER ---
  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    bool isPassword = false
  }) {
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