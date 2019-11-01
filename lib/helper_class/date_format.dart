import "package:intl/intl.dart";

String formatDate() {

  var now = DateTime.now();
  return DateFormat("EEE, MMM d, ''yy").format(now);
}