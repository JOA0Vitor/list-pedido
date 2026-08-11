import 'package:intl/intl.dart';

String formatarData(String dataApi) {
  try {
    final dateTime = DateTime.parse(dataApi);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  } catch (_) {
    final diasCache = int.tryParse(dataApi);
    if (diasCache != null) {
      final data = DateTime(1840, 12, 31).add(Duration(days: diasCache));
      return DateFormat('dd/MM/yyyy').format(data);
    }
    return '-';
  }
}