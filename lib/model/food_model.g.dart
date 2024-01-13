// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodModelFromJson(Map<String, dynamic> json) => FoodModel(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FoodModelToJson(FoodModel instance) => <String, dynamic>{
      'meals': instance.meals,
    };

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      idMeal: json['idMeal'] as String?,
      strMeal: json['strMeal'] as String?,
      strDrinkAlternate: json['strDrinkAlternate'],
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strInstructions: json['strInstructions'] as String?,
      strMealThumb: json['strMealThumb'] as String?,
      strTags: json['strTags'] as String?,
      strYoutube: json['strYoutube'] as String?,
      strSource: json['strSource'] as String?,
      strImageSource: json['strImageSource'],
      strCreativeCommonsConfirmed: json['strCreativeCommonsConfirmed'],
      dateModified: json['dateModified'],
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'idMeal': instance.idMeal,
      'strMeal': instance.strMeal,
      'strDrinkAlternate': instance.strDrinkAlternate,
      'strCategory': instance.strCategory,
      'strArea': instance.strArea,
      'strInstructions': instance.strInstructions,
      'strMealThumb': instance.strMealThumb,
      'strTags': instance.strTags,
      'strYoutube': instance.strYoutube,
      'strSource': instance.strSource,
      'strImageSource': instance.strImageSource,
      'strCreativeCommonsConfirmed': instance.strCreativeCommonsConfirmed,
      'dateModified': instance.dateModified,
    };
