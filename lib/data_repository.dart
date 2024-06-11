import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String userName = "";
  static String firstName = "";
  static String lastName = "";
  static String phone = "";
  static String email = "";
  static EncryptedSharedPreferences prefs = EncryptedSharedPreferences();

  static void loadData() {
    prefs.getString("first").then((String value) {
      if(value != "") {
        firstName = value;
      }
    });
    prefs.getString("last").then((String value) {
      if(value != "") {
        lastName = value;
      }
    });
    prefs.getString("phone").then((String value) {
      if(value != "") {
        phone = value;
      }
    });
    prefs.getString("email").then((String value) {
      if(value != "") {
        email = value;
      }
    });
  }

  static void saveData() {
      prefs.setString("first", firstName);
      prefs.setString("last", lastName);
      prefs.setString("phone", phone);
      prefs.setString("email", email);
  }
}