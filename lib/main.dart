import 'package:flutter/material.dart';
import 'package:pagedao/main_provider.dart';
import 'package:pagedao/screens/home_scaffold/home_screen.dart';
import 'package:pagedao/screens/test_home_screen.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAoJcc6e6P5GhiSZqK6f4IuAF6Oybdja48",
        authDomain: "page-dao.firebaseapp.com",
        projectId: "page-dao",
        storageBucket: "page-dao.appspot.com",
        messagingSenderId: "943695472464",
        appId: "1:943695472464:web:cb17294d2fb4a85fa2ae55",
        measurementId: "G-YFZ5K2WVRC"),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (context, value, _) {
          return MaterialApp(
            title: 'We are PageDAO',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(255, 255, 243, 167)),
              scaffoldBackgroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              primaryColor: const Color.fromARGB(255, 255, 255, 255),
              iconTheme: const IconThemeData().copyWith(color: Colors.white),
              fontFamily: 'Montserrat',
              textTheme: const TextTheme(
                headline2: TextStyle(
                  color: Color.fromARGB(255, 33, 33, 33),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                headline4: TextStyle(
                  fontSize: 12.0,
                  color: Color.fromARGB(255, 33, 33, 33),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                ),
                bodyText1: TextStyle(
                  color: Color.fromARGB(255, 33, 33, 33),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
                bodyText2: TextStyle(
                  color: Color.fromARGB(255, 33, 33, 33),
                  letterSpacing: 1.0,
                ),
              ),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: const Color(0xFF2D93F9)),
            ),
            themeMode: themeMode.value,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
              scaffoldBackgroundColor: const Color(0xFF121212),
              backgroundColor: const Color(0xFF121212),
              primaryColor: Colors.black,
              accentColor: const Color(0xFF2D93F9),
              iconTheme: const IconThemeData().copyWith(color: Colors.white),
              fontFamily: 'Montserrat',
              textTheme: TextTheme(
                headline2: const TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                headline4: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                ),
                bodyText1: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
                bodyText2: TextStyle(
                  color: Colors.grey[300],
                  letterSpacing: 1.0,
                ),
              ),
            ),
            home: ChangeNotifierProvider<ValueNotifier<ThemeMode>>.value(
                value: themeMode,
                child: WillPopScope(
                    //forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
                    onWillPop: () async {
                      return false;
                    },
                    child: const MainProvider(child: TestHomeScaffold()))),
          );
        });
  }
}
