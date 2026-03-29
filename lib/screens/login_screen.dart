import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_screen.dart'; // Ensure this matches your file name

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

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
              SizedBox(height: 100),
              // --- APP LOGO SECTION ---
              Icon(Icons.shield_outlined, size: 80, color: Colors.blue[800]),
              SizedBox(height: 10),
              Text(
                "CampusGuard",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue[900]),
              ),
              Text("Your Safety, Our Priority", style: TextStyle(color: Colors.grey[600])),
              
              SizedBox(height: 60),

              // --- EMAIL FIELD ---
              _buildTextField(
                controller: _emailController,
                hint: "University Email",
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 20),

              // --- PASSWORD FIELD ---
              _buildTextField(
                controller: _passwordController,
                hint: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              
              SizedBox(height: 40),

              // --- LOGIN BUTTON ---
              _isLoading 
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                      ),
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        try {
                          await authVm.signIn(_emailController.text, _passwordController.text);
                          // Navigate to Home if successful
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Failed: Check credentials")),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                      child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
              
              SizedBox(height: 20),
              TextButton(
                onPressed: () { /* Add Navigation to Sign Up */ },
                child: Text("Don't have an account? Sign Up", style: TextStyle(color: Colors.blue[800])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for cleaner code
  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blue[800]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}