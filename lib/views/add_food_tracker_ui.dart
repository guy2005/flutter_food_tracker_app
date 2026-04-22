import 'dart:io';
import 'package:flutter/material.dart';
// แก้ชื่อ package เป็น food_tracker_app2
import 'package:food_tracker_app2/services/supabase_service.dart';
import 'package:food_tracker_app2/Models/food.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddFoodTrackerUi extends StatefulWidget {
  const AddFoodTrackerUi({super.key});

  @override
  State<AddFoodTrackerUi> createState() => _AddFoodTrackerUiState();
}

class _AddFoodTrackerUiState extends State<AddFoodTrackerUi> {
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();
  
  String selectedMeal = 'เช้า'; 
  String? foodImageUrl = '';
  File? file;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() { file = File(picked.path); });
    }
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() { foodDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked); });
    }
  }

  Future<void> save() async {
    if (foodNameCtrl.text.isEmpty || foodPriceCtrl.text.isEmpty || foodPersonCtrl.text.isEmpty || foodDateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาป้อนข้อมูลให้ครบทุกช่อง'), backgroundColor: Colors.red));
      return;
    }

    final service = SupabaseService();
    if (file != null) {
      foodImageUrl = await service.uploadFile(file!);
    }

    final food = Food(
      foodName: foodNameCtrl.text,
      foodMeal: selectedMeal,
      foodPrice: double.tryParse(foodPriceCtrl.text) ?? 0.0,
      foodPerson: int.tryParse(foodPersonCtrl.text) ?? 1,
      foodDate: foodDateCtrl.text,
      foodImageUrl: foodImageUrl ?? '',
    );

    await service.insertFood(food);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget mealButton(String title) {
    bool isSelected = selectedMeal == title;
    return ElevatedButton(
      onPressed: () { setState(() { selectedMeal = title; }); },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF44336),
        title: const Text('Food Tracker (เพิ่ม)', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            InkWell(
              onTap: pickImage,
              child: file == null ? Icon(Icons.add_a_photo, size: 100, color: Colors.grey[400]) : Image.file(file!, width: 150, height: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('กินอะไร')),
            TextField(controller: foodNameCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'เช่น KFC, Pizza')),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินมื้อไหน')),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              mealButton('เช้า'), mealButton('กลางวัน'), mealButton('เย็น'), mealButton('ว่าง'),
            ]),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินไปกี่บาท')),
            TextField(controller: foodPriceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'เช่น 299.50')),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินกันกี่คน')),
            TextField(controller: foodPersonCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'เช่น 3')),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินไปวันไหน')),
            TextField(controller: foodDateCtrl, readOnly: true, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'เช่น 2020-01-31', suffixIcon: Icon(Icons.calendar_today)), onTap: pickDate),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: save, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)), child: const Text("บันทึก", style: TextStyle(color: Colors.white))),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() { foodNameCtrl.clear(); foodPriceCtrl.clear(); foodPersonCtrl.clear(); foodDateCtrl.clear(); file = null; selectedMeal = 'เช้า'; });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 50)),
              child: const Text("ยกเลิก", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}