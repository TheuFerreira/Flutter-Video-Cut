import 'package:flutter_video_cut/domain/services/datetime_service.dart';
import 'package:intl/intl.dart';

class DateTimeServiceImpl implements DateTimeService {
  final Intl _intl = Intl();
  @override
  String getFormattedDateToFileName(DateTime date) {
    DateFormat dateFormat = _intl.date('yyyyMMddhhmmss');
    final formattedDate = dateFormat.format(date);
    return formattedDate;
  }
}
