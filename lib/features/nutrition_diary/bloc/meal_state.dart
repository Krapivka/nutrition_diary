import 'package:equatable/equatable.dart';

import '../models/meal.dart';

class MealState extends Equatable {
  final MealStatus status;
  final DateTime currDateTime;
  final List<Meal> meals;
  final List<Meal> sortedMeals;
  const MealState({
    this.status = MealStatus.loading,
    this.meals = const <Meal>[],
    this.sortedMeals = const <Meal>[],
    required this.currDateTime,
  });

  @override
  List<Object> get props => [status, meals, sortedMeals, currDateTime];

  MealState copyWith({
    MealStatus? status,
    List<Meal>? meals,
    List<Meal>? sortedMeals,
    DateTime? currDateTime,
  }) {
    return MealState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      sortedMeals: sortedMeals ?? this.sortedMeals,
      currDateTime: currDateTime ?? this.currDateTime,
    );
  }

  @override
  String toString() {
    return '''MealState { status: $status, Meals: ${meals.length} }''';
  }
}

enum MealStatus { loading, loaded }
