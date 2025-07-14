import 'package:equatable/equatable.dart';

import '../models/meal.dart';

class MealState extends Equatable {
  final MealStatus status;
  final DateTime currDateTime;
  final List<Meal> meals;
  const MealState({
    this.status = MealStatus.loading,
    this.meals = const <Meal>[],
    required this.currDateTime,
  });

  @override
  List<Object> get props => [status, meals, currDateTime];

  MealState copyWith({
    MealStatus? status,
    List<Meal>? meals,
    DateTime? currDateTime,
  }) {
    return MealState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      currDateTime: currDateTime ?? this.currDateTime,
    );
  }

  @override
  String toString() {
    return '''MealState { status: $status, Meals: ${meals.length} }''';
  }
}

enum MealStatus { loading, loaded }
