import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:original_sana/database/cloud_firestore/data_provider.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    service.SystemChrome.setPreferredOrientations([
      service.DeviceOrientation.portraitUp,
      service.DeviceOrientation.portraitDown
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyDatabase()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        routes: {
          NavBar.id: (context) => NavBar(),
          SplashScreen.id: (context) => SplashScreen(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
