

abstract class HiveConstants {
  static const String userBox = "userBox";
  static const String locationBox = "locationBox";

  static const String userModel = "userModel";
  static const String userPhone = "userPhone";
  static const String locationsModels = "locationsModels";
  static const String defaultLocationId = "defaultLocationId";

  static void registerHiveTypeAdapters() {
    // Hive.registerAdapter(AddressTypeAdapter());
    // Hive.registerAdapter(LocationModelTypeAdapter());
    // Hive.registerAdapter(AppGenderAdapter());
    // Hive.registerAdapter(UserModelAdapter());
  }
}

abstract class HiveObjectId {
  static const int userModelId = 0;
  static const int tokensId = 1;
  static const int locationModelId = 2;
  static const int addressTypeId = 3;
  static const int genderTypeId = 4;
}
