import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msig_food/bloc/food_bloc/food_bloc.dart';
import 'package:msig_food/drift/favorite.dart';
import 'package:msig_food/model/food_model.dart';
import 'package:msig_food/ui/widget/image_not_found_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:drift/drift.dart' as drift;

class FoodDetailScreen extends StatefulWidget {
  final String? id;
  const FoodDetailScreen({Key? key, this.id}) : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final FoodBloc _foodBloc = FoodBloc();
  bool isFavorite = false;
  late Database _database;

  @override
  void initState() {
    _database = Database();
    _foodBloc.add(GetFoodDetail(widget.id!));

    _database.getFavorite(widget.id!).then((favoriteData) {
      setState(() {
        isFavorite = favoriteData != null;
      });
    });
    super.initState();
  }

  @override
  void dispose(){
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFE64F53),
        title: const Text('Food Detail', style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
      ),
      body: _buildListFood(),
    );
  }

  Widget _buildListFood() {
    return Container(
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
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FancyShimmerImage(
                          width: double.infinity,
                          boxFit: BoxFit.cover,
                          imageUrl: model.meals![index].strMealThumb!,
                          errorWidget: const ImageNotFoundWidget()),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(model.meals![index].strMeal!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFE64F53))),
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () async {
                        if (isFavorite) {
                          await _database.deleteFavorite(model.meals![index].idMeal!);
                        } else {
                          final entity = FavoriteCompanion(
                            idFood: drift.Value(model.meals![index].idMeal!),
                            image: drift.Value(model.meals![index].strMealThumb!),
                            title: drift.Value(model.meals![index].strMeal!),
                            category: drift.Value(model.meals![index].strCategory!),
                            area: drift.Value(model.meals![index].strArea!),
                          );
                          _database.insertFavorite(entity);
                        }

                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        final snackBar = SnackBar(
                          backgroundColor: isFavorite ? Colors.green : Colors.red,
                          content: Text(
                            isFavorite
                                ? 'Saved to favorites'
                                : 'Removed from favorites',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text("Category : ${model.meals![index].strCategory}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black54)),
                const SizedBox(height: 5),
                Text("Area : ${model.meals![index].strArea}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black54)),
                const SizedBox(height: 5),
                Text("Area : ${model.meals![index].strArea}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black54)),
                const SizedBox(height: 10),
                const Text('Instruction',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFE64F53))),
                const SizedBox(height: 5),
                Text("${model.meals![index].strInstructions}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black54)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final Uri _url = Uri.parse(model.meals![index].strSource!);
                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: const Text('See More...',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: const Color(0xFFE64F53))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}