import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'event_list_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quoteVm = Provider.of<QuoteViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "CampusGuard",
          style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await authVm.signOut();
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (_) => LoginScreen())
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- QUOTE OF THE DAY CARD (Professional Style) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Column(
                children: [
                  Text(
                    "Quote of the Day", 
                    style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 10),
                  if (quoteVm.isLoading)
                    const CircularProgressIndicator()
                  else
                    Text(
                      '"${quoteVm.currentQuote?.text ?? "Stay vigilant."}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue[800]),
                    ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => quoteVm.loadRandomQuote(),
                    child: const Text("Get New Quote"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- THE CORE BUTTONS (The "Main Idea") ---
            
            // 1. VIEW EVENTS BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 2,
              ),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => EventListScreen())
              ),
              icon: const Icon(Icons.list_alt_rounded, size: 28),
              label: const Text(
                "VIEW EVENTS FEED", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),

            const SizedBox(height: 20),

            // 2. MY PROFILE BUTTON
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                side: BorderSide(color: Colors.blue[900]!, width: 2),
                foregroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => ProfileScreen())
              ),
              icon: const Icon(Icons.person_pin_rounded, size: 28),
              label: const Text(
                "MY PROFILE", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
            
            const SizedBox(height: 40),
            
            // --- SAFETY TIP ---
            Center(
              child: Text(
                "Always report suspicious activity immediately.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}