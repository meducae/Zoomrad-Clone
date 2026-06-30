import 'package:flutter/material.dart';
import 'package:zoomradclone/presentation/auth/PhoneEntryScreen.dart';
import 'package:zoomradclone/utils/themes/theme_menager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Auth UI',
      themeMode: _themeManager.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF109C5B),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF109C5B),
      ),
      locale: _themeManager.locale,
      home: PhoneEntryScreen(themeManager: _themeManager),
    );
  }
}