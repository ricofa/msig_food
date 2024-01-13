import 'package:msig_food/api/api_provider.dart';
import 'package:msig_food/model/food_model.dart';

class Repository{
  final _apiProvider = ApiProvider();

  Future<FoodModel?> getFoodList(){
    return _apiProvider.getFoodList();
  }
  
  Future<FoodModel?> getFoodDetail(id){
    return _apiProvider.getFoodDetail(id);
  }
}

class NetworkError extends Error {}