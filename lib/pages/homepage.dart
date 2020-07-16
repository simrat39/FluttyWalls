import 'package:flutter/material.dart';

import '../models/WallpaperModel.dart';

import '../widgets/FadeIn.dart';
import 'package:infinity_ui/infinity_ui.dart';
import '../widgets/colored_scrollbar.dart';
import 'package:provider/provider.dart';
import '../models/FavouritesProvider.dart';
import '../widgets/image_tile.dart';
import '../models/FavouriteModel.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pop(
        complicatedGridViewWithHeader(
          context,
        ),
      ),
    );
  }

  Widget complicatedGridViewWithHeader(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (WallpaperModel.wallpapers.isNotEmpty)
      return Container(
        margin: EdgeInsets.only(
          top: InfinityUi.statusBarHeight,
        ),
        padding: EdgeInsets.only(
          left: width * 0.019,
        ),
        child: Container(
          padding: EdgeInsets.only(right: width * 0.019),
          child: AccentedScrollbar(
            highlightColor: Theme.of(context).accentColor,
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                      bottom: height * 0.02,
                    ),
                    child: Text(
                      "Wallpapers",
                      style: TextStyle(
                        fontSize: height / width * 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (width * 0.003).ceil(),
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider<FavouriteModel>.value(
                            value: FavouriteModel.providerList[index],
                          ),
                          ChangeNotifierProvider<FavouritesProvider>.value(
                            value: FavouritesProvider.provider,
                          ),
                        ],
                        child: ImageTile(
                          url: WallpaperModel.wallpapers[index].url,
                          name: WallpaperModel.wallpapers[index].name,
                          author: WallpaperModel.wallpapers[index].author,
                          index: WallpaperModel.wallpapers[index].index,
                          heroTagName: WallpaperModel.wallpapers[index].index
                                  .toString() +
                              "FromWallsName",
                          heroTagHeart: WallpaperModel.wallpapers[index].index
                                  .toString() +
                              "FromWallsHeart",
                          heroTagImage: WallpaperModel.wallpapers[index].index
                                  .toString() +
                              "FromWallsImage",
                        ),
                      );
                    },
                    childCount: WallpaperModel.wallpapers.length,
                  ),
                ),
                // shrinkWrap: true,
              ],
            ),
          ),
        ),
      );
    else
      return Container();
  }
}
