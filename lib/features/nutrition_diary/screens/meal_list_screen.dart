import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/meal_bloc.dart';
import '../bloc/meal_state.dart';
import '../models/meal.dart';
import '../widgets/meal_cart.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Дневник Питания"),
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            if (state.status == MealStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == MealStatus.loaded) {
              final List<Meal> mealsForSelectedDate = state.sortedMeals;

              int sumFats = 0;
              int sumProteins = 0;
              int sumCarbs = 0;
              int sumCalories = 0;
              for (int i = 0; i < state.sortedMeals.length; i++) {
                sumProteins += mealsForSelectedDate[i].proteins ?? 0;
                sumFats += mealsForSelectedDate[i].fats ?? 0;
                sumCarbs += mealsForSelectedDate[i].carbs ?? 0;
                sumCalories += mealsForSelectedDate[i].calories ?? 0;
              }
              return Column(children: [
                //Ж:$sumFats  У:$sumCarbs Калории:$sumCalories"
                Row(children: [
                  NutritionalValueCard(
                    title: "Б",
                    value: sumProteins,
                    cardColor: const Color.fromARGB(255, 253, 250, 92),
                  ),
                  NutritionalValueCard(
                    title: "Ж",
                    value: sumFats,
                    cardColor: const Color.fromARGB(255, 92, 253, 146),
                  ),
                  NutritionalValueCard(
                    title: "У",
                    value: sumCarbs,
                    cardColor: const Color.fromARGB(255, 253, 143, 92),
                  ),
                  NutritionalValueCard(
                    title: "кКал",
                    value: sumCalories,
                    cardColor: Colors.orangeAccent,
                  ),
                ]),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: mealsForSelectedDate.length,
                    itemBuilder: (context, index) {
                      final meal = mealsForSelectedDate[index];
                      return MealCard(key: ValueKey(meal.id), meal: meal);
                    },
                  ),
                )
              ]);
            } else {
              return const Center(child: Text('Ошибка загрузки'));
            }
          },
        ),
      ),
    );
  }
}

class NutritionalValueCard extends StatelessWidget {
  final String title;
  final int value;
  final Color? cardColor;
  const NutritionalValueCard({
    super.key,
    required this.title,
    required this.value,
    this.cardColor = Colors.blueGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: cardColor,
        child: Container(
            height: 35,
            decoration: const BoxDecoration(),
            child: Center(child: Text("$title:$value "))),
      ),
    ));
  }
}
