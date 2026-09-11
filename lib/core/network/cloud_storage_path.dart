
import 'package:onyx_todo/core/injection/injection_container.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';
import 'package:onyx_todo/core/storage/shared_preferences/shared_pref_keys.dart';

abstract class CloudStoragePath {
  static String get _userId {
    final id = getIt<AppPreferences>().getString(PrefKeys.userId);

    if (id.isEmpty) return '';

    return '/$id';
  }

  static const String _bankTransfer = 'payment/bank_transfer';
  static String get orderBankTransferReceipt => '$_bankTransfer/order$_userId';
  static String get subscriptionBankTransferReceipt =>
      '$_bankTransfer/subscription$_userId';
}
