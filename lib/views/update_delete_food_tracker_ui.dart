import 'dart:io';
import 'package:flutter/material.dart';
// แก้ชื่อ package เป็น food_tracker_app2
import 'package:food_tracker_app2/Models/food.dart';
import 'package:food_tracker_app2/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateDeleteFoodTrackerUi extends StatefulWidget {
  final Food food;
  const UpdateDeleteFoodTrackerUi({super.key, required this.food});

  @override
  State<UpdateDeleteFoodTrackerUi> createState() => _UpdateDeleteFoodTrackerUiState();
}

class _UpdateDeleteFoodTrackerUiState extends State<UpdateDeleteFoodTrackerUi> {
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();
  
  String selectedMeal = 'เช้า';
  String? foodImageUrl = '';
  File? file;

  @override
  void initState() {
    super.initState();
    foodNameCtrl.text = widget.food.foodName ?? '';
    foodPriceCtrl.text = widget.food.foodPrice?.toString() ?? '';
    foodPersonCtrl.text = widget.food.foodPerson?.toString() ?? '1';
    foodDateCtrl.text = widget.food.foodDate ?? '';
    selectedMeal = widget.food.foodMeal ?? 'เช้า';
    foodImageUrl = widget.food.foodImageUrl ?? '';
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) { setState(() { file = File(picked.path); }); }
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (picked != null) { setState(() { foodDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked); }); }
  }

  Future<void> update() async {
    if (foodNameCtrl.text.isEmpty || foodPriceCtrl.text.isEmpty || foodPersonCtrl.text.isEmpty || foodDateCtrl.text.isEmpty) return;
    
    final service = SupabaseService();
    if (file != null) {
      if (widget.food.foodImageUrl != null && widget.food.foodImageUrl!.isNotEmpty) {
        await service.deleteFile(widget.food.foodImageUrl!);
      }
      foodImageUrl = await service.uploadFile(file!);
    }

    final updatedFood = Food(
      foodName: foodNameCtrl.text,
      foodMeal: selectedMeal,
      foodPrice: double.tryParse(foodPriceCtrl.text) ?? 0.0,
      foodPerson: int.tryParse(foodPersonCtrl.text) ?? 1,
      foodDate: foodDateCtrl.text,
      foodImageUrl: foodImageUrl ?? '',
    );
    
    await service.updateFood(widget.food.id!, updatedFood);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> delete() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบข้อมูลนี้หรือไม่?'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              final service = SupabaseService();
              if (widget.food.foodImageUrl != null && widget.food.foodImageUrl!.isNotEmpty) {
                await service.deleteFile(widget.food.foodImageUrl!);
              }
              await service.deleteFood(widget.food.id!); 
              if (!mounted) return;
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            }, 
            child: const Text('ยืนยัน')
          ),
        ]
      ),
    );
  }

  Widget mealButton(String title) {
    bool isSelected = selectedMeal == title;
    return ElevatedButton(
      onPressed: () { setState(() { selectedMeal = title; }); },
      style: ElevatedButton.styleFrom(backgroundColor: isSelected ? Colors.green : Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFF44336), title: const Text('Food Tracker (แก้ไข/ลบ)', style: TextStyle(color: Colors.white)), centerTitle: true, leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            InkWell(
              onTap: pickImage,
              child: file != null ? Image.file(file!, width: 150, height: 150, fit: BoxFit.cover) : (foodImageUrl != null && foodImageUrl!.isNotEmpty) ? Image.network(foodImageUrl!, width: 150, height: 150, fit: BoxFit.cover) : Icon(Icons.add_a_photo, size: 100, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('กินอะไร')),
            TextField(controller: foodNameCtrl, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินมื้อไหน')),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [mealButton('เช้า'), mealButton('กลางวัน'), mealButton('เย็น'), mealButton('ว่าง')]),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินไปกี่บาท')),
            TextField(controller: foodPriceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินกันกี่คน')),
            TextField(controller: foodPersonCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const Align(alignment: Alignment.centerLeft, child: Text('กินไปวันไหน')),
            TextField(controller: foodDateCtrl, readOnly: true, decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), onTap: pickDate),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: update, style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)), child: const Text("บันทึกแก้ไข", style: TextStyle(color: Colors.white))),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: delete, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(double.infinity, 50)), child: const Text("ลบข้อมูล", style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}