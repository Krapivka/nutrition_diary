import 'package:equatable/equatable.dart';

import '../models/meal.dart';

class AddOrUpdateMealEvent extends MealEvent {
  final Meal meal;
  AddOrUpdateMealEvent(this.meal);

  @override
  List<Object?> get props => [meal];
}

class ChangedDateEvent extends MealEvent {
  final DateTime dateTime;
  ChangedDateEvent(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class DeleteMealEvent extends MealEvent {
  final Meal meal;
  DeleteMealEvent(this.meal);

  @override
  List<Object?> get props => [meal];
}

class LoadMealsEvent extends MealEvent {
  @override
  List<Object?> get props => [];
}

abstract class MealEvent extends Equatable {}
