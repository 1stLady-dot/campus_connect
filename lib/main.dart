/* 
* ================================================== 
* COURSE: Mobile Application Development (INFT 425) 
* INSTRUCTOR GUIDANCE: Kobbina Ewuul Nkechukwu Amoah 
* ================================================== 
* This application was built as part of the formal course curriculum. 
* Every major feature and implementation approach follows the 
* structured guidance provided by the course instructor. 
*  
* Unauthorized reproduction or removal of this notice is a violation 
* of academic integrity and professional attribution standards. 
*/

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
  const MyApp({super.key});

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