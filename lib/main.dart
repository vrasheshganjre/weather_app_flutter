
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData.light(useMaterial3: true).copyWith(
            textTheme: GoogleFonts.robotoMonoTextTheme(
                ThemeData(brightness: Brightness.light).textTheme),
            colorScheme: const ColorScheme.light()),
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            textTheme: GoogleFonts.robotoMonoTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme),
            appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
            colorScheme: const ColorScheme.dark().copyWith()),
        initialBinding:
            BindingsBuilder.put(() => HomeController(), permanent: true),
        home: const HomeScreen());
  }
}
