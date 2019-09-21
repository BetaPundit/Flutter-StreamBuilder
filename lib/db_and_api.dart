import 'package:proj_1/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SharedPreferenceImplementation implements SimpleStorage {

  SharedPreferences _sharedPreferences;
  SharedPreferenceImplementation._(this._sharedPreferences);

  static Future<SharedPreferenceImplementation> getInstance () async {
    return SharedPreferenceImplementation._(await SharedPreferences.getInstance());
  }

  @override
  Future<int> readCount() async {
    if (_sharedPreferences.containsKey("counter"))
      return _sharedPreferences.get("counter");
    return null;
  }

  @override
  Future<String> readMessage() async {
    if (_sharedPreferences.containsKey("message"))
      return _sharedPreferences.get("message");
    return null;
  }

  @override
  Future<void> writeCount(int count) async {
    await _sharedPreferences.setInt("counter", count);
  }

  @override
  Future<void> writeMessage(String message) async {
    await _sharedPreferences.setString("message", message); 
  }
}


class OnlineApiImplementation extends OnlineAPI {
  @override
  Future<String> getAdviceJsonString() async {
    var response = await http.get("https://api.adviceslip.com/advice");
    if (response.statusCode == 200) {
      return response.body;
    }
    throw "Unhandled expection - Failed fetching from api";
  }
}