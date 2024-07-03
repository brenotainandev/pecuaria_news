import 'package:intl/intl.dart';

class AppDateFormatters {
  static String mdY(DateTime dt) => DateFormat(
        'd MMM, yyyy',
      ).format(dt);
}
