import 'package:flutter/material.dart';
// แก้ชื่อ package เป็น food_tracker_app2
import 'package:food_tracker_app2/views/show_all_food_tracker_ui.dart'; 

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ShowAllFoodTrackerUi()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF44336), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/food.png', 
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Food Tracker',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '🍔🍟🌭🍿🍨🧁',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.yellow,
            )
          ],
        ),
      ),
    );
  }
}