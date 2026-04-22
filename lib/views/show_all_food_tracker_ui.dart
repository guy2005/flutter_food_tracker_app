import 'package:flutter/material.dart';
import 'package:food_tracker_app2/Models/food.dart';
import 'package:food_tracker_app2/services/supabase_service.dart';
import 'package:food_tracker_app2/views/add_food_tracker_ui.dart';
import 'package:food_tracker_app2/views/update_delete_food_tracker_ui.dart';

class ShowAllFoodTrackerUi extends StatefulWidget {
  const ShowAllFoodTrackerUi({super.key});

  @override
  State<ShowAllFoodTrackerUi> createState() => _ShowAllFoodTrackerUiState();
}

class _ShowAllFoodTrackerUiState extends State<ShowAllFoodTrackerUi> {
  final service = SupabaseService();
  List<Food> foods = [];

  void loadFoods() async {
    final data = await service.getFoods();
    setState(() {
      foods = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF44336),
        title: const Text(
          'Food Tracker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF44336),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFoodTrackerUi()),
          ).then((value) => loadFoods());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          const SizedBox(height: 20),
          // เปลี่ยนรูปใหญ่เป็น food.png แล้วครับ
          Image.asset('assets/images/food.png', width: 150, height: 150, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateDeleteFoodTrackerUi(food: foods[index]),
                        ),
                      ).then((value) => loadFoods());
                    },
                    leading: (foods[index].foodImageUrl != null && foods[index].foodImageUrl != "")
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(foods[index].foodImageUrl!, width: 60, height: 60, fit: BoxFit.cover),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            // เปลี่ยนรูปรอง (กรณีไม่มีภาพ) เป็น food.png แล้วครับ
                            child: Image.asset('assets/images/food.png', width: 60, height: 60, fit: BoxFit.cover),
                          ),
                    title: Text('กิน: ${foods[index].foodName ?? ""}'),
                    subtitle: Text('วันที่: ${foods[index].foodDate ?? ""} มื้อ: ${foods[index].foodMeal ?? ""}'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
                    tileColor: Colors.green[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}