
import 'package:intl/intl.dart';

extension DateTimeDate on DateTime {
  String toYyyyMmDd() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
