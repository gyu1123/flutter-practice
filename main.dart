import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'data/home_screen.dart';
import 'data/profile.dart';
import 'data/record_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(() async {
    runApp(MyApp());
  },(error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);

  });



}
class MyApp extends StatelessWidget {
  final analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Signika'),
      routes: {
        'home': (context) => HomeScreen(),
        'hydration': (context) => profileScreen(),
        'record': (context) => RecordScreen(),
      },

      initialRoute: 'home',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }

}





