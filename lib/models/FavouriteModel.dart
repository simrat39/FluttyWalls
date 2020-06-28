import 'package:flutter/material.dart';

import '../utils/FavouriteUtils.dart';

import 'FavouritesProvider.dart';

class FavouriteModel with ChangeNotifier {
  String _url;
  bool _isFavourite;
  IconData _icon;

  static List<FavouriteModel> providerList = [];

  FavouriteModel(String url) {
    _url = url;
    setIsFavourite();
  }

  // getters
  bool get isFavourite => _isFavourite;
  IconData get icon => _icon;

  void toggleIcon() {
    _icon = _isFavourite == true ? Icons.favorite : Icons.favorite_border;
    notifyListeners();
  }

  void setIsFavourite() async {
    _isFavourite =
        await FavouriteUtils.isUrlFavourite(_url).whenComplete(() {});
    toggleIcon();
  }

  void toggleFavourite() async {
    await FavouriteUtils.toggleFromFavourite(_url).whenComplete(() {
      _isFavourite = !_isFavourite;
      toggleIcon();
    });
    FavouritesProvider.provider.notifyListeners();
    notifyListeners();
  }
}
