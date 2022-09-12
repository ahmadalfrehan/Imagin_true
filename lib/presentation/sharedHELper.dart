import 'package:shared_preferences/shared_preferences.dart';

class Shard {
  static SharedPreferences? sharedprefrences;

  static initial() async {
    sharedprefrences = await SharedPreferences.getInstance();
  }

  static saveData({required String key, required dynamic value}) async {
    if (value is String) return await sharedprefrences!.setString(key, value);
    if (value is int) return await sharedprefrences!.setInt(key, value);
    if (value is bool) return await sharedprefrences!.setBool(key, value);
    return await sharedprefrences!.setDouble(key, value);
  }

  static getData({required String key}) async {
    return sharedprefrences?.get(key);
  }
}
