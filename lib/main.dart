import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:olympia/firebase_options.dart';

import 'package:olympia/page/home/home_page.dart';

import 'package:olympia/utils/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColor.bottomBar,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color accentClr = AppColor.accent;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phonk Me',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColor.theme,
        useMaterial3: true,
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: accentClr,
          primary: accentClr,
          surfaceTint: Colors.transparent,
        ),
        datePickerTheme: DatePickerThemeData(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColor.theme,
          dividerColor: accentClr,
          elevation: 10,
          shadowColor: accentClr,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5),
            ),
          ),
          cancelButtonStyle: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.grey),
          ),
        ),
      ),
      home: const HomePage(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}
