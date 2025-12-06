import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/settings_service.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsService().loadSettings();
  runApp(const MyNotepadApp());
}

class MyNotepadApp extends StatelessWidget {
  const MyNotepadApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsService(),
      builder: (context, _) {
        final mode = SettingsService().themeMode;
        ThemeData theme;
        
        if (mode == 'system') {
           final brightness = MediaQuery.of(context).platformBrightness;
           theme = brightness == Brightness.dark 
             ? ThemeData.dark().copyWith(
                 scaffoldBackgroundColor: Colors.black,
                 primaryColor: Colors.amber, 
                 colorScheme: const ColorScheme.dark(primary: Colors.amber, secondary: Colors.amberAccent),
                 appBarTheme: AppBarTheme(
                   iconTheme: const IconThemeData(color: Colors.white),
                   titleTextStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                 ),
                 textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
               )
             : ThemeData.light().copyWith(
                 scaffoldBackgroundColor: Colors.white,
                 primaryColor: Colors.amber,
                 colorScheme: const ColorScheme.light(primary: Colors.amber, secondary: Colors.black),
                 appBarTheme: AppBarTheme(
                   iconTheme: const IconThemeData(color: Colors.black),
                   titleTextStyle: GoogleFonts.outfit(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                 ),
                 textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
               );
        } else if (mode == 'light') {
          theme = ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: GoogleFonts.outfit(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
          );
        } else if (mode == 'kawaii') {
          theme = ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: const Color(0xFFFFF0F5), 
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(secondary: Colors.tealAccent),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.pinkAccent),
              titleTextStyle: GoogleFonts.pacifico(color: Colors.pinkAccent, fontSize: 28),
            ),
            textTheme: GoogleFonts.quicksandTextTheme(ThemeData.light().textTheme),
          );
        } else if (mode == 'cyberpunk') {
          theme = ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.cyan,
            scaffoldBackgroundColor: const Color(0xFF0D0221), 
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent, 
              secondary: Colors.purpleAccent,
              surface: Color(0xFF1A1A40),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.cyanAccent),
              titleTextStyle: GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 26, letterSpacing: 2),
            ),
            textTheme: GoogleFonts.exo2TextTheme(ThemeData.dark().textTheme).apply(
              bodyColor: Colors.cyanAccent.withOpacity(0.8),
              displayColor: Colors.white,
            ),
          );
        } else if (mode == 'coffee') {
           theme = ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF4E342E),
            scaffoldBackgroundColor: const Color(0xFFEFEBE9),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6D4C41),
              secondary: Color(0xFF8D6E63),
              surface: Color(0xFFD7CCC8), 
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
              titleTextStyle: GoogleFonts.merriweather(color: const Color(0xFF3E2723), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF5D4037),
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.loraTextTheme(ThemeData.light().textTheme).apply(
              bodyColor: const Color(0xFF3E2723),
            ),
          );
        } else if (mode == 'dracula') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF282a36),
            primaryColor: const Color(0xFFbd93f9),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFbd93f9),
              secondary: Color(0xFFff79c6),
              surface: Color(0xFF44475a),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFFbd93f9)),
              titleTextStyle: GoogleFonts.firaCode(color: Color(0xFFbd93f9), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            textTheme: GoogleFonts.firaCodeTextTheme(ThemeData.dark().textTheme),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFbd93f9),
              foregroundColor: Color(0xFF282a36),
            ),
          );
        } else if (mode == 'nord') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF2e3440),
            primaryColor: const Color(0xFF88c0d0),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF88c0d0),
              secondary: Color(0xFF81a1c1),
              surface: Color(0xFF3b4252),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF88c0d0)),
              titleTextStyle: GoogleFonts.rubik(color: Color(0xFF88c0d0), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
             floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF5e81ac),
              foregroundColor: Colors.white,
            ),
          );
        } else if (mode == 'sunset') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF2d1b2e),
            primaryColor: const Color(0xFFfd5e53),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFfd5e53),
              secondary: Color(0xFFff9e80),
              surface: Color(0xFF4a2c4a),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFFfd5e53)),
              titleTextStyle: GoogleFonts.poppins(color: Color(0xFFfd5e53), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          );
        } else if (mode == 'coder') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.dark(
              primary: Colors.greenAccent,
              secondary: Colors.lightGreenAccent,
              surface: Color(0xFF111111),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.greenAccent),
              titleTextStyle: GoogleFonts.vt323(color: Colors.greenAccent, fontSize: 32),
            ),
            textTheme: GoogleFonts.vt323TextTheme(ThemeData.dark().textTheme).apply(
              bodyColor: Colors.greenAccent,
              displayColor: Colors.greenAccent,
            ),
          );
        } else if (mode == 'minimal') {
          theme = ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.black,
            colorScheme: const ColorScheme.light(primary: Colors.black, secondary: Colors.grey),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: GoogleFonts.inter(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
            ),
            textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          );
        } else if (mode == 'minimal_more') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF263238),
            primaryColor: const Color(0xFFB0BEC5),
            colorScheme: const ColorScheme.dark(primary: Color(0xFFB0BEC5), secondary: Colors.white70),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFFECEFF1)),
              titleTextStyle: GoogleFonts.lato(color: Color(0xFFECEFF1), fontSize: 24, fontWeight: FontWeight.w300),
            ),
            textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
          );
        } else if (mode == 'thinkpad') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF101010),
            primaryColor: const Color(0xFFFF0000),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF0000), 
              secondary: Color(0xFFFF0000), 
              surface: Color(0xFF202020)
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFFFF0000)),
              titleTextStyle: GoogleFonts.ibmPlexSans(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFFF0000),
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.ibmPlexSansTextTheme(ThemeData.dark().textTheme),
          );
        } else if (mode == 'nature') {
          theme = ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1B5E20),
            primaryColor: const Color(0xFF81C784),
            colorScheme: const ColorScheme.dark(primary: Color(0xFF81C784), secondary: Colors.lightGreenAccent),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: GoogleFonts.raleway(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme),
          );
        } else if (mode == 'sky') {
          theme = ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFE3F2FD),
            primaryColor: const Color(0xFF2196F3),
            colorScheme: const ColorScheme.light(primary: Color(0xFF2196F3), secondary: Colors.blueAccent),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF1565C0)),
              titleTextStyle: GoogleFonts.nunito(color: Color(0xFF1565C0), fontSize: 26, fontWeight: FontWeight.w800),
            ),
             floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
          );
        } else {
          theme = ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: Colors.black,
             appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          );
        }

        return MaterialApp(
          title: 'My Notepad',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: const HomePage(),
        );
      }
    );
  }
}
