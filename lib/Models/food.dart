// ไฟล์ที่สร้างขึ้นเพื่อแมปกับข้อมูลตาราง food_tracker_tb
class Food {
  String? id;
  String? foodDate;
  String? foodMeal;
  String? foodName;
  double? foodPrice;
  int? foodPerson;
  String? foodImageUrl;

  Food({
    this.id,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
    this.foodImageUrl,
  });

  // แปลงข้อมูลจาก Database (JSON) มาเป็น Object
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json['id']?.toString(),
        // ถ้าค่าวันที่เป็น null หรือมีปัญหา ให้ส่งค่าว่างมาแทน จะได้ไม่พัง
        foodDate: json['foodDate']?.toString() ?? '',
        foodMeal: json['foodMeal']?.toString() ?? '',
        foodName: json['foodName']?.toString() ?? '',
        // ดักจับ Error เผื่อค่า price ส่งมาเป็นตัวหนังสือแทนที่จะเป็นตัวเลข
        foodPrice: json['foodPrice'] != null ? double.tryParse(json['foodPrice'].toString()) : 0.0,
        // ดักจับ Error เผื่อค่า person ส่งมาเป็นตัวหนังสือ
        foodPerson: json['foodPerson'] != null ? int.tryParse(json['foodPerson'].toString()) : 1,
        foodImageUrl: json['foodImageUrl']?.toString() ?? '',
      );

  // แปลง Object เป็น JSON ส่งกลับไปเก็บบน Database
  Map<String, dynamic> toJson() => {
        'foodDate': foodDate,
        'foodMeal': foodMeal,
        'foodName': foodName,
        'foodPrice': foodPrice,
        'foodPerson': foodPerson,
        'foodImageUrl': foodImageUrl,
      };
}