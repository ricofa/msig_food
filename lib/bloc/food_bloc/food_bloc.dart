import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:msig_food/api/repository.dart';
import 'package:msig_food/model/food_model.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    final Repository _repository = Repository();

    on<GetFoodList>((event, emit) async {
      try{
        emit(FoodLoading());
        final foodList = await _repository.getFoodList();
        emit(FoodData(foodList!));
      } on NetworkError {
        emit(const FoodError("Failed get Data. Network not connected"));
      }
    });

    on<GetFoodDetail>((event, emit) async {
      try{
        emit(FoodLoading());
        final foodList = await _repository.getFoodDetail(event.id);
        emit(FoodData(foodList!));
      } on NetworkError {
        emit(const FoodError("Failed get Data. Network not connected"));
      }
    });
  }
}
