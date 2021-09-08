import 'package:news_app/layout/news_app/app_cubit/app_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{

  static late SharedPreferences sharedPreferences;

  static init()async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putData ({
  required String key,
    required bool value,
})async{
    return await sharedPreferences.setBool(key, value);
  }
  static bool? getData ({
    required String key,
  }){
    return  sharedPreferences.getBool(key);
  }
}
