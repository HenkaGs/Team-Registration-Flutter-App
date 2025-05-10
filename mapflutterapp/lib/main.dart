import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapflutterapp/firebase_service.dart';
import 'firebase_options.dart';
import 'ui/start_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        // Add your providers here, e.g.,
        // ChangeNotifierProvider(create: (_) => YourNotifier()),
        StreamProvider<User?>.value(
                initialData: null,
                value: AuthService().user,
              ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Namibia Hockey',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartScreen(),
    );
  }
}
