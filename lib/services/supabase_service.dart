import 'dart:io';
// แก้ชื่อ package เป็น food_tracker_app2
import 'package:food_tracker_app2/Models/food.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Food>> getFoods() async {
    final data = await supabase.from('food_tracker_tb').select('*');
    return data.map((food) => Food.fromJson(food)).toList();
  }

  Future<String?> uploadFile(File file) async {
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    try {
      await supabase.storage.from('food_tracker_bk').upload(filename, file);
      return supabase.storage.from('food_tracker_bk').getPublicUrl(filename);
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }

  Future insertFood(Food food) async {
    await supabase.from('food_tracker_tb').insert(food.toJson());
  }

  Future deleteFile(String filename) async {
    filename = filename.split('/').last;
    await supabase.storage.from('food_tracker_bk').remove([filename]);
  }

  Future updateFood(String id, Food food) async {
    await supabase.from('food_tracker_tb').update(food.toJson()).eq('id', id);
  }

  Future deleteFood(String id) async {
    await supabase.from('food_tracker_tb').delete().eq('id', id);
  }
}