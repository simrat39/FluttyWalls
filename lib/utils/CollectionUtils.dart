import '../models/WallpaperModel.dart';

class CollectionUtils {
  static Map<String, List<String>> collections = {};

  static void makeCollections() {
    List<WallpaperModel> walls = WallpaperModel.wallpapers;

    for (int i = 0; i < walls.length; i++) {
      if (collections.containsKey(walls[i].collections)) {
        collections[walls[i].collections].add(walls[i].url);
      } else {
        collections[walls[i].collections] = [walls[i].url];
      }
    }
  }
}
