import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/Screens/AddEvent/add_screen.dart';
import 'package:mobilki/Screens/Calendar/calendar_page.dart';
import 'package:mobilki/Screens/Invites/invites_screen.dart';
import 'package:mobilki/Screens/Social/social_screen.dart';
import 'package:mobilki/resources/firestore_methods.dart';
import 'package:mobilki/screens/Home/home_screen.dart';
import 'package:mobilki/screens/Start/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/navbar.dart';
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
    User? _user = FirebaseAuth.instance.currentUser;
    String firstScreen;
    Navbar.init();
    if (_user != null) {
      firstScreen = 'home';
      FirebaseMessaging.instance.onTokenRefresh
          .listen(FireStoreMethods.saveTokenToDatabase);
    } else {
      firstScreen = 'start';
    }
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BasketballAppka',
            theme: ThemeData(
                textTheme:
                    GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
            initialRoute: firstScreen,
            routes: {
              'start': (context) => const StartScreen(),
              'register': (context) => const RegisterScreen(),
              'login': (context) => const LoginScreen(),
              'search': (context) => const SearchScreen(),
              'home': (context) => const HomeScreen(),
              'people': (context) => const SocialScreen(),
              'invites': (context) => const InvitesScreen(),
              'event': (context) => const CalendarScreen(),
              'add': (context) => const AddScreen(),
            }));
  }
}
