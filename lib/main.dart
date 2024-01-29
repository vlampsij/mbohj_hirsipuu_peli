import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'naytot/koti.dart';
import 'naytot/pisteet.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //debug banner pois näkymästä

      //teema
      theme: ThemeData.dark().copyWith(
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(5.0),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.0,
            letterSpacing: 5.0,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF421b9b),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: GoogleFonts.creepster().fontFamily,
            ),
      ),
      initialRoute: 'kotiSivu',
      routes: {
        'kotiSivu': (context) => KotiNaytto(),
        'pisteSivu': (context) => const PisteNaytto(),
      },
    );
  }
}
