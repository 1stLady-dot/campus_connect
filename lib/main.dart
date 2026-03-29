import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/event_viewmodel.dart';
import 'viewmodels/quote_viewmodel.dart';
import 'screens/login_screen.dart';

void main() async {
  // 1. Ensure Flutter is ready for background tasks
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Only initialize Firebase if it isn't already running
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => EventViewModel()),
        // This loads your "Quote of the Day" feature for the dashboard
        ChangeNotifierProvider(create: (_) => QuoteViewModel()..loadRandomQuote()),
      ],
      child: MaterialApp(
        title: 'Campus Connect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Modern look for your Week 8/9 submission
        ),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}