import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:msig_food/model/food_model.dart';

class ApiProvider {
  final Dio _dio = Dio();

  Future<FoodModel?> getFoodList()async {
    try{
      Response response = await _dio.get('https://www.themealdb.com/api/json/v1/1/search.php?s=');
      return FoodModel.fromJson(response.data);
    }catch(error, stacktrace){
      if (kDebugMode) {
        print("Exception occurred: $error stackTrace: $stacktrace");
      }
    }
  }

  Future<FoodModel?> getFoodDetail(id)async {
    try{
      Response response = await _dio.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
      return FoodModel.fromJson(response.data);
    }catch(error, stacktrace){
      if (kDebugMode) {
        print("Exception occurred: $error stackTrace: $stacktrace");
      }
    }
  }
}