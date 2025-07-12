import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'features/nutrition_diary/bloc/meal_bloc.dart';
import 'features/nutrition_diary/bloc/meal_event.dart';
import 'features/nutrition_diary/bloc/meal_state.dart';
import 'features/nutrition_diary/models/meal.dart';
import 'features/nutrition_diary/screens/meal_list_screen.dart';
import 'features/nutrition_diary/screens/nutrition_calendar_screen.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Tracker',
      locale: const Locale('ru', 'RU'),
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: BlocProvider(
        create: (_) => MealBloc()..add(LoadMealsEvent()),
        child: const NutritionApp(),
      ),
    );
  }
}

class NutritionApp extends StatefulWidget {
  const NutritionApp({Key? key}) : super(key: key);

  @override
  State<NutritionApp> createState() => _NutritionAppState();
}

class _NutritionAppState extends State<NutritionApp> {
  int _currentIndex = 0;
  //DateTime _selectedDate = DateTime.now();

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const MealListScreen(),
      const NutritionCalendarScreen(),
    ];

    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.restaurant, title: 'Приемы пищи'),
          TabItem(icon: Icons.calendar_month, title: 'Календарь'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? BlocBuilder<MealBloc, MealState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        const uuid = Uuid();
                        final meal = Meal(
                          id: uuid.v4(),
                          date: context.read<MealBloc>().state.currDateTime,
                        );
                        context
                            .read<MealBloc>()
                            .add(AddOrUpdateMealEvent(meal));
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton.extended(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              context.read<MealBloc>().state.currDateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          //locale: const Locale('ru', 'RU'),
                        );
                        if (picked != null &&
                            picked !=
                                context.read<MealBloc>().state.currDateTime) {
                          context
                              .read<MealBloc>()
                              .add(ChangedDateEvent(picked));
                        }
                      },
                      label: Text(DateFormat('dd.MM.yyyy')
                          .format(context.read<MealBloc>().state.currDateTime)),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                );
              },
            )
          : null,
    );
  }
}
