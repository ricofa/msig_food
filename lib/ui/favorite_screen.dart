import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:msig_food/drift/favorite.dart';
import 'package:msig_food/ui/food_detail_screen.dart';
import 'package:msig_food/ui/widget/image_not_found_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Database _database;
  @override
  void initState() {
    _database = Database();
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
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFE64F53),
          title: const Text('Your Favorite', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
        ),
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<FavoriteData>>(
            future: _database.getFavorites(),
            builder: (context, snapshot) {
              final List<FavoriteData>? fav = snapshot.data;
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (fav != null) {
                return ListView.builder(
                  itemCount: fav.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FoodDetailScreen(id: fav[index].idFood)),
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
                                        imageUrl: fav[index].image,
                                        errorWidget:
                                        const ImageNotFoundWidget()),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Food: ${fav[index].title}"),
                                        Text(
                                            "Category: ${fav[index].category}"),
                                        Text("Area: ${fav[index].area}"),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red,),
                                  onPressed: () async {
                                    await _database.deleteFavorite(fav[index].idFood);
                                    setState(() {
                                      _database.getFavorites();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              return const Text('No data found');
            }));
  }
}