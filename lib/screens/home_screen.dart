import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'event_list_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

// Changed to StatefulWidget to allow for initState
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    // This triggers the API call as soon as the Home Screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuoteViewModel>(context, listen: false).loadRandomQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This is now "listening" for when notifyListeners() is called in the ViewModel
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
                  
                  // --- THE LOGIC CHECK ---
                  if (quoteVm.isLoading)
                    const CircularProgressIndicator()
                  else if (quoteVm.currentQuote != null)
                    Text(
                      '"${quoteVm.currentQuote!.text}"', // Uses the dynamic text
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue[800]),
                    )
                  else
                    const Text("Stay vigilant.", style: TextStyle(color: Colors.grey)),
                    
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => quoteVm.loadRandomQuote(),
                    child: const Text("Get New Quote"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

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