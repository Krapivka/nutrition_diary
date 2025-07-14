import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';
import 'meal_event.dart';
import 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc() : super(MealState(currDateTime: DateTime.now())) {
    on<LoadMealsEvent>(_onLoad);
    on<AddOrUpdateMealEvent>(_onAddOrUpdate);
    on<DeleteMealEvent>(_onDelete);
    on<ChangedDateEvent>(_onChangeDate);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _onAddOrUpdate(
      AddOrUpdateMealEvent event, Emitter<MealState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('meals') ?? [];
    final meals = data.map((e) => Meal.fromJson(jsonDecode(e))).toList();

    final index = meals.indexWhere((m) => m.id == event.meal.id);
    if (index >= 0) {
      meals[index] = event.meal;
    } else {
      meals.add(event.meal);
    }

    final encoded = meals.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('meals', encoded);
    emit(state.copyWith(meals: meals, status: MealStatus.loaded));
  }

  Future<void> _onChangeDate(
      ChangedDateEvent event, Emitter<MealState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('meals') ?? [];
    final meals = data.map((e) => Meal.fromJson(jsonDecode(e))).toList();

    emit(state.copyWith(
        currDateTime: event.dateTime, status: MealStatus.loaded));
  }

  Future<void> _onDelete(DeleteMealEvent event, Emitter<MealState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('meals') ?? [];
    final meals = data.map((e) => Meal.fromJson(jsonDecode(e))).toList();

    meals.removeWhere((m) => m.id == event.meal.id);
    final sortedMeals = meals
        .where((element) => isSameDay(element.date, state.currDateTime))
        .toList();
    for (var element in sortedMeals) {
      debugPrint(element.id);
    }
    final encoded = meals.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('meals', encoded);
    emit(state.copyWith(meals: meals, status: MealStatus.loaded));
  }

  Future<void> _onLoad(LoadMealsEvent event, Emitter<MealState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('meals') ?? [];
    final meals = data.map((e) => Meal.fromJson(jsonDecode(e))).toList();
    emit(state.copyWith(meals: meals, status: MealStatus.loaded));
  }
}
