class Meal {
  final String id;
  final String? name;
  final int? proteins;
  final int? fats;
  final int? carbs;
  final int? calories;
  final DateTime date;

  Meal({
    required this.id,
    required this.date,
    this.name,
    this.proteins,
    this.fats,
    this.carbs,
    this.calories,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'proteins': proteins,
        'fats': fats,
        'carbs': carbs,
        'calories': calories,
        'date': date.toIso8601String(),
      };

  static Meal fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'],
        name: json['name'],
        proteins: json['proteins'],
        fats: json['fats'],
        carbs: json['carbs'],
        calories: json['calories'],
        date: DateTime.parse(json['date']),
      );
}
