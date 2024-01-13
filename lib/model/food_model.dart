import 'package:json_annotation/json_annotation.dart';

part 'food_model.g.dart';

@JsonSerializable()
class FoodModel {
  @JsonKey(name: 'meals')
  List<Meal>? meals;

  FoodModel({
    this.meals,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);
}

@JsonSerializable()
class Meal {
  @JsonKey(name: 'idMeal')
  String? idMeal;
  @JsonKey(name: 'strMeal')
  String? strMeal;
  @JsonKey(name: 'strDrinkAlternate')
  dynamic strDrinkAlternate;
  @JsonKey(name: 'strCategory')
  String? strCategory;
  @JsonKey(name: 'strArea')
  String? strArea;
  @JsonKey(name: 'strInstructions')
  String? strInstructions;
  @JsonKey(name: 'strMealThumb')
  String? strMealThumb;
  @JsonKey(name: 'strTags')
  String? strTags;
  @JsonKey(name: 'strYoutube')
  String? strYoutube;
  @JsonKey(name: 'strSource')
  String? strSource;
  @JsonKey(name: 'strImageSource')
  dynamic strImageSource;
  @JsonKey(name: 'strCreativeCommonsConfirmed')
  dynamic strCreativeCommonsConfirmed;
  @JsonKey(name: 'dateModified')
  dynamic dateModified;

  Meal(
      {this.idMeal,
      this.strMeal,
      this.strDrinkAlternate,
      this.strCategory,
      this.strArea,
      this.strInstructions,
      this.strMealThumb,
      this.strTags,
      this.strYoutube,
      this.strSource,
      this.strImageSource,
      this.strCreativeCommonsConfirmed,
      this.dateModified});

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
