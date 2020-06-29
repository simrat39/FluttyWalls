class WallpaperModel {
  String name;
  String url;
  String author;
  String collections;
  int index;

  static List<WallpaperModel> wallpapers = [];

  WallpaperModel(
      {String name, String url, String author, String collections, int index}) {
    this.name = name;
    this.url = url;
    this.author = author;
    this.collections = collections;
    this.index = index;
  }
}
