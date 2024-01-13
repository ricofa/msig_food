part of 'food_bloc.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class GetFoodList extends FoodEvent {}
class GetFoodDetail extends FoodEvent {
  String id;
  GetFoodDetail(this.id);
}
