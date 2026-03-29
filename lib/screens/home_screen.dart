import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'event_list_screen.dart';
import 'add_event_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quoteVm = Provider.of<QuoteViewModel>(context);
    final authVm = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "CampusGuard Dashboard",
          style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.blue[900]),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await authVm.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- WELCOME TEXT ---
            Text("Hello, student!", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            Text("Stay Safe Today", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            
            const SizedBox(height: 25),

            // --- QUOTE OF THE DAY CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue[800]!, Colors.blue[600]!]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_quote, color: Colors.white70),
                      SizedBox(width: 10),
                      Text("Daily Inspiration", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (quoteVm.isLoading)
                    CircularProgressIndicator(color: Colors.white)
                  else if (quoteVm.errorMessage != null)
                    Text("Stay vigilant and keep the campus safe.", style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic))
                  else
                    Text(
                      '"${quoteVm.currentQuote?.text}"',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                    ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => quoteVm.loadRandomQuote(),
                    child: Text("Refresh Quote", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- NAVIGATION CARDS ---
            Text("Safety Tools", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            const SizedBox(height: 15),
            
            Row(
              children: [
                _buildMenuCard(
                  context,
                  title: "Safety Feed",
                  subtitle: "View Alerts",
                  icon: Icons.notifications_active_outlined,
                  color: Colors.orange[50]!,
                  iconColor: Colors.orange[800]!,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventListScreen())),
                ),
                const SizedBox(width: 15),
                _buildMenuCard(
                  context,
                  title: "Emergency",
                  subtitle: "Get Help",
                  icon: Icons.sos_rounded,
                  color: Colors.red[50]!,
                  iconColor: Colors.red[800]!,
                  onTap: () { /* Future SOS Feature */ },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGET FOR MENU CARDS ---
  Widget _buildMenuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required Color iconColor, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: iconColor.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 30),
              const SizedBox(height: 15),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 16)),
              Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}