import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String formattedDateUtil(DateTime? date) {
  if (date == null) return 'Date inconnue';

  initializeDateFormatting('fr_FR', null);

  final dateFormat = DateFormat('EEEE d MMMM y', 'fr_FR');
  final formattedDate = dateFormat.format(date);

  final words = formattedDate.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.isEmpty) return '';
    return word[0].toUpperCase() + word.substring(1);
  });

  return capitalizedWords.join(' ');
}