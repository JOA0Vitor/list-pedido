import 'package:intl/intl.dart';

String formatarData(String dataApi) {
  final dateTime = DateTime.parse(dataApi);

  return DateFormat('dd/MM/yyyy').format(dateTime);
}