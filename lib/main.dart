import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/provider/provider.dart';
import 'package:notes_app/view/add_note.dart';
import 'package:notes_app/view/home_screen.dart';
import 'package:notes_app/view/registration_screen.dart';
import 'package:notes_app/view/signin_screen.dart';
import 'package:notes_app/view/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => ProviderNote(),
    child: MyApp(),
  ));
}

late User? signedUser;
final firebase = FirebaseAuth.instance;

bool isSigned() {
  signedUser = firebase.currentUser;
  if (signedUser != null) {
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat app',
      initialRoute:
          isSigned() ? HomeScreen.routeScreen : SigninScreen.routeScreen,
      routes: {
        WelcomeScreen.routeScreen: (context) => WelcomeScreen(),
        SigninScreen.routeScreen: (context) => SigninScreen(),
        RegistrationScreen.routeScreen: (context) => RegistrationScreen(),
        HomeScreen.routeScreen: (context) => HomeScreen(),
        AddNote.routeScreen: (context) => AddNote(),
      },
    );
  }
}
