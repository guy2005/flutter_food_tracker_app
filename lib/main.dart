import 'package:flutter/material.dart';

import 'package:food_tracker_app2/views/splash_screen_ui.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    // เอา /rest/v1/ ออกให้แล้วนะครับ!
    url: 'https://eooaaugwkdzpjjdccczd.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvb2FhdWd3a2R6cGpqZGNjY3pkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2NjE4MTYsImV4cCI6MjA5MjIzNzgxNn0.a90ktEJt5rbhO1UdsjDPZn_gEons9OHYGqvPXMX4fwQ', 
  );
  
  runApp(const FlutterFoodTrackerApp());
}

class FlutterFoodTrackerApp extends StatefulWidget {
  const FlutterFoodTrackerApp({super.key});

  @override
  State<FlutterFoodTrackerApp> createState() => _FlutterFoodTrackerAppState();
}

class _FlutterFoodTrackerAppState extends State<FlutterFoodTrackerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Tracker', 
      home: const SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
