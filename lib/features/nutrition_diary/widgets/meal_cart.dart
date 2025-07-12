import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/meal_bloc.dart';
import '../bloc/meal_event.dart';
import '../models/meal.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  const MealCard({Key? key, required this.meal}) : super(key: key);

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late TextEditingController nameController;
  late TextEditingController proteinsController;
  late TextEditingController fatsController;
  late TextEditingController carbsController;
  late TextEditingController caloriesController;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Название'),
                    onChanged: (_) => _updateMeal(),
                  ),
                ),
                IconButton(
                  onPressed: _deleteMeal,
                  icon: const Icon(Icons.delete, color: Colors.red),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTextField('Белки', proteinsController, isNumber: true),
                const SizedBox(width: 10),
                _buildTextField('Жиры', fatsController, isNumber: true),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTextField('Углеводы', carbsController, isNumber: true),
                const SizedBox(width: 10),
                _buildTextField('Калории', caloriesController, isNumber: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.meal.name ?? '');
    proteinsController =
        TextEditingController(text: widget.meal.proteins?.toString() ?? '');
    fatsController =
        TextEditingController(text: widget.meal.fats?.toString() ?? '');
    carbsController =
        TextEditingController(text: widget.meal.carbs?.toString() ?? '');
    caloriesController =
        TextEditingController(text: widget.meal.calories?.toString() ?? '');
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
        onChanged: (_) => _updateMeal(),
      ),
    );
  }

  void _deleteMeal() {
    context.read<MealBloc>().add(DeleteMealEvent(widget.meal));
  }

  void _updateMeal() {
    final updatedMeal = Meal(
      id: widget.meal.id,
      name: nameController.text,
      proteins: int.tryParse(proteinsController.text),
      fats: int.tryParse(fatsController.text),
      carbs: int.tryParse(carbsController.text),
      calories: int.tryParse(caloriesController.text),
      date: widget.meal.date,
    );
    context.read<MealBloc>().add(AddOrUpdateMealEvent(updatedMeal));
  }
}
