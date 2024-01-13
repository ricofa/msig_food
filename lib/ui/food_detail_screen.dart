import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msig_food/bloc/food_bloc/food_bloc.dart';
import 'package:msig_food/model/food_model.dart';
import 'package:msig_food/ui/widget/image_not_found_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodDetailScreen extends StatefulWidget {
  String? id;
  FoodDetailScreen({this.id});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final FoodBloc _foodBloc = FoodBloc();

  @override
  void initState() {
    _foodBloc.add(GetFoodDetail(widget.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Detail')),
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
                Text(model.meals![index].strMeal!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 5),
                Text("Category : ${model.meals![index].strCategory}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey)),
                const SizedBox(height: 5),
                Text("Area : ${model.meals![index].strArea}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey)),
                const SizedBox(height: 5),
                Text("Area : ${model.meals![index].strArea}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey)),
                const SizedBox(height: 10),
                const Text('Instruction',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 5),
                Text("${model.meals![index].strInstructions}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    final Uri _url = Uri.parse(model.meals![index].strSource!);
                    if (!await launchUrl(_url)) {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: const Text('See More',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.blue)),
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