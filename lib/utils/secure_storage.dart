import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shishughar/utils/globle_method.dart';

class SecureStorage {
  SecureStorage._();
  static FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: "shishu_android_storage"),
    iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
        groupId: "shiishu_iOS_storage"),
  );

  static Future<void> writeStringValue(String key, String value) async {
    await storage.write(key: key, value: value);
    print("Value stored : $value ****");
  }

  static Future<void> writeIntvalue(String key, int value) async {
    await storage.write(key: key, value: value.toString());
  }

  static Future<void> writeBoolvalue(String key, bool value) async {
    await storage.write(key: key, value: value ? 'true' : 'false');
  }

  static Future<bool?> readBoolValue(String key) async {
    String? value = await storage.read(key: key);
    if (Global.validString(value)) {
      return value!.contains('true') ? true : false;
    }
    return null;
  }

  static Future<String?> readStringValue(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  static Future<int?> readIntValue(String key) async {
    String? value = await storage.read(key: key);
    return Global.stringToInt(value);
  }

  static Future<void> deleteValue(String key) async {
    await storage.delete(key: key);
  }
}
