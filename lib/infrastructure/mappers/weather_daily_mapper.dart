import 'package:simpleweather/domain/domain.dart';

import '../../config/helpers/parsing.dart';

class WeatherDailyMapper {
  static WeatherDaily jsonToEntity(Map<String, dynamic> json) {
    Map<String, String> dailyUnits =
        (json['daily_units'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value.toString()));

    Map<String, dynamic> daily = json['daily'];

    List<DateTime> days = List<DateTime>.from(
        daily['time'].map((x) => DateTime.tryParse(x.toString())));
    List<double> minTemperature = List<double>.from(
        daily['temperature_2m_min'].map((x) => Parsing.tryDouble(x)));
    List<double> maxTemperature = List<double>.from(
        daily['temperature_2m_max'].map((x) => Parsing.tryDouble(x)));
    List<int> weatherCode =
        List<int>.from(daily['weather_code'].map((x) => Parsing.tryInt(x)));

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

  static Map<String, dynamic> entityToJson(WeatherDaily weatherDaily) {
    List<String> days =
        List<String>.from(weatherDaily.days.map((x) => x.toString()));

    return {
      "timezone": weatherDaily.timezone,
      "timezone_abbreviation": weatherDaily.timezoneAbreviation,
      "daily_units": {
        "time": weatherDaily.dailyUnits["time"],
        "temperature_2m_max": weatherDaily.dailyUnits["temperature_2m_max"],
        "temperature_2m_min": weatherDaily.dailyUnits["temperature_2m_min"],
        "weather_code": weatherDaily.dailyUnits["weather_code"],
      },
      "daily": {
        "time": days,
        "temperature_2m_max": weatherDaily.maxTemperature,
        "temperature_2m_min": weatherDaily.minTemperature,
        "weather_code": weatherDaily.weatherCode,
      },
    };
  }
}
