import 'package:shared_preferences/shared_preferences.dart';

class FavouriteUtils {
  static Future<void> init() async {
    if (await getFavourites() == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('favourites_url_list', []);
    }
  }

  static Future<bool> isUrlFavourite(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> urls = prefs.getStringList('favourites_url_list');
    if (urls.contains(url)) {
      return true;
    }
    return false;
  }

  static Future<void> addUrlToFavourite(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> urls = prefs.getStringList('favourites_url_list');
    urls.add(url);
    prefs.setStringList('favourites_url_list', urls);
  }

  static Future<void> removeUrlFromFavourite(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> urls = prefs.getStringList('favourites_url_list');
    urls.remove(url);
    prefs.setStringList('favourites_url_list', urls);
  }

  static Future<List<String>> getFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> urls = prefs.getStringList('favourites_url_list');
    return urls;
  }

  static Future<void> toggleFromFavourite(String url) async {
    if (await isUrlFavourite(url).whenComplete(() {})) {
      removeUrlFromFavourite(url);
    } else {
      addUrlToFavourite(url);
    }
  }
}
