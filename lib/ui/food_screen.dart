import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msig_food/bloc/food_bloc/food_bloc.dart';
import 'package:msig_food/drift/favorite.dart';
import 'package:msig_food/model/food_model.dart';
import 'package:msig_food/ui/favorite_screen.dart';
import 'package:msig_food/ui/food_detail_screen.dart';
import 'package:msig_food/ui/widget/image_not_found_widget.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  late Database _database;
  final FoodBloc _foodBloc = FoodBloc();

  @override
  void initState() {
    _database = Database();
    _foodBloc.add(GetFoodList());
    super.initState();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFE64F53),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoriteScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )),
            )
          ],
          title: const Text(
            'MSIG Food',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          )),
      body: Container(
          color: Colors.grey[200],
          child: _buildListFood()),
    );
  }

  Widget _buildListFood() {
    return Container(
      // color: Colors.grey[200],
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _foodBloc,
        child: BlocListener<FoodBloc, FoodState>(
          listener: (context, state) {
            if (state is FoodError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<FoodBloc, FoodState>(
            builder: (context, state) {
              if (state is FoodInitial) {
                return _buildLoading();
              } else if (state is FoodLoading) {
                return _buildLoading();
              } else if (state is FoodData) {
                return _buildCard(context, state.foodModel);
              } else if (state is FoodError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, FoodModel model) {
    return ListView.builder(
      itemCount: model.meals!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FoodDetailScreen(id: model.meals![index].idMeal)),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FancyShimmerImage(
                            width: 100,
                            height: 100,
                            imageUrl: model.meals![index].strMealThumb!,
                            errorWidget: const ImageNotFoundWidget()),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Food: ${model.meals![index].strMeal}"),
                            Text(
                                "Category: ${model.meals![index].strCategory}"),
                            Text("Area: ${model.meals![index].strArea}"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
