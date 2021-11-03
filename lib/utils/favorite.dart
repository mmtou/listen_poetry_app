import 'package:shared_preferences/shared_preferences.dart';

class Favorite {
  static SharedPreferences? prefs;
  static List<String>? favorites;

  static Future<bool> getInstance() async {
    prefs = await SharedPreferences.getInstance();
    favorites = prefs!.getStringList('favorites') ?? [];
    return true;
  }

  static favorite(type, id) {
    String item = '$type:$id';
    if (!isFavorite(type, id)) {
      favorites!.add(item);
      prefs!.setStringList('favorites', favorites!);
    }
  }

  static bool isFavorite(type, id) {
    String item = '$type:$id';
    return favorites!.contains(item);
  }
}
