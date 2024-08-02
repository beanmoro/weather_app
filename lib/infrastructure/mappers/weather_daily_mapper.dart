import 'package:weather_app/domain/domain.dart';

class WeatherDailyMapper {
  static WeatherDaily jsonToEntity(Map<String, dynamic> json) {
    Map<String, String> dailyUnits =
        (json['daily_units'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value.toString()));

    Map<String, dynamic> daily = json['daily'];

    List<DateTime> days = List<DateTime>.from(
        daily['time'].map((x) => DateTime.tryParse(x.toString())));
    List<double> minTemperature =
        List<double>.from(daily['temperature_2m_min'].map((x) => x));
    List<double> maxTemperature =
        List<double>.from(daily['temperature_2m_max'].map((x) => x));
    List<int> weatherCode = List<int>.from(daily['weather_code'].map((x) => x));

    return WeatherDaily(
      timezone: json['timezone'],
      timezoneAbreviation: json['timezone_abbreviation'],
      dailyUnits: dailyUnits,
      days: days,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      weatherCode: weatherCode,
    );
  }
}
