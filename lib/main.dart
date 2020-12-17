import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:original_sana/database/cloud_firestore/data_provider.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => MyDatabase()),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        routes: {
          NavBar.id: (context) => NavBar(),
          SplashScreen.id: (context) => SplashScreen(),
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
