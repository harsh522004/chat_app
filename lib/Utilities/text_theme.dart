import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/Colors.dart';

class HtextTheme{
   static TextTheme hTextTheme = TextTheme(
     headlineLarge: GoogleFonts.ubuntu(
         fontSize: 28.0, fontWeight: FontWeight.bold, color: materialColor[50]),
     headlineMedium: GoogleFonts.ubuntu(
         fontSize: 24.0, fontWeight: FontWeight.bold, color: materialColor[50]),
     headlineSmall: GoogleFonts.ubuntu(
         fontSize: 16.0, fontWeight: FontWeight.bold, color: materialColor[50]),



     titleLarge: GoogleFonts.ubuntu(
         fontSize: 16.0, fontWeight: FontWeight.w600, color:materialColor[50]),
     titleMedium: GoogleFonts.ubuntu(
         fontSize: 14.0, fontWeight: FontWeight.w600, color: materialColor[50]),


     bodyLarge: GoogleFonts.ubuntu(
         fontSize: 16.0, fontWeight: FontWeight.normal, color: materialColor[50]),
     bodyMedium: GoogleFonts.ubuntu(
         fontSize: 14.0, fontWeight: FontWeight.normal, color: materialColor[50]),
   );
}