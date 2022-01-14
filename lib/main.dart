import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/screens/Home/home_screen.dart';
import 'package:mobilki/screens/Start/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/Home/home_screen.dart';
import 'screens/Login/login_screen.dart';
import 'screens/Register/register_screen.dart';
import 'screens/Search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StartScreen',
        theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
        initialRoute: '/',
        routes: {
          '/': (context) => const StartScreen(),
          '/register': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/search': (context) => const SearchScreen(),
          '/home': (context) => const HomeScreen(),
        });
  }
}
