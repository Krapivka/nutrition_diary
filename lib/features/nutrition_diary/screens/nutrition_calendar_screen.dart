import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../bloc/meal_bloc.dart';
import '../bloc/meal_state.dart';

class NutritionCalendarScreen extends StatefulWidget {
  const NutritionCalendarScreen({super.key});

  @override
  State<NutritionCalendarScreen> createState() =>
      _NutritionCalendarScreenState();
}

class _NutritionCalendarScreenState extends State<NutritionCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Календарь питания"),
      ),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          final mealsForSelectedDay = state.meals
              .where((meal) => isSameDay(meal.date, _selectedDay))
              .toList();

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final hasMeal =
                        state.meals.any((meal) => isSameDay(meal.date, day));
                    if (hasMeal) {
                      return const Positioned(
                        bottom: 1,
                        child:
                            Icon(Icons.circle, size: 6.0, color: Colors.green),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: mealsForSelectedDay.isEmpty
                    ? const Center(child: Text('Нет записей на этот день'))
                    : ListView.builder(
                        itemCount: mealsForSelectedDay.length,
                        itemBuilder: (context, index) {
                          final meal = mealsForSelectedDay[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text(meal.name ?? 'Прием пищи'),
                              subtitle: Text(
                                'Б: ${meal.proteins ?? '-'} | Ж: ${meal.fats ?? '-'} | У: ${meal.carbs ?? '-'} | К: ${meal.calories ?? '-'}',
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
