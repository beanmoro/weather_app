import 'package:simpleweather/config/helpers/parsing.dart';
import 'package:simpleweather/domain/domain.dart';

class WeatherMapper {
  static Weather jsonToEntity(Map<String, dynamic> json) {
    Map<String, String> hourlyUnits =
        (json['hourly_units'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value.toString()));
    Map<String, dynamic> hourly = json['hourly'];
    List<DateTime> time = List<DateTime>.from(
        hourly['time'].map((x) => DateTime.tryParse(x.toString())));
    List<double> temperature = List<double>.from(
        hourly['temperature_2m'].map((x) => Parsing.tryDouble(x)));
    List<double> apparentTemperature = List<double>.from(
        hourly['apparent_temperature'].map((x) => Parsing.tryDouble(x)));
    List<int> relativeHumidity = List<int>.from(
        hourly['relative_humidity_2m'].map((x) => Parsing.tryInt(x)));
    List<int> weatherCode =
        List<int>.from(hourly['weather_code'].map((x) => Parsing.tryInt(x)));
    return Weather(
      timezone: json['timezone'],
      timezoneAbreviation: json['timezone_abbreviation'] ?? "",
      hourlyUnits: hourlyUnits,
      time: time,
      temperature: temperature,
      apparentTemperature: apparentTemperature,
      relativeHumidity: relativeHumidity,
      weatherCode: weatherCode,
    );
  }

  static Map<String, dynamic> entityToJson(Weather weather) {
    List<String> time =
        List<String>.from(weather.time.map((x) => x.toString()));

    return {
      "timezone": weather.timezone,
      "timezone_abreviation": weather.timezoneAbreviation,
      "hourly_units": {
        "time": weather.hourlyUnits["time"].toString(),
        "temperature_2m": weather.hourlyUnits["temperature_2m"],
        "relative_humidity_2m": weather.hourlyUnits["relative_humidity_2m"],
        "apparent_temperature": weather.hourlyUnits["apparent_temperature"],
        "weather_code": weather.hourlyUnits["weather_code"],
      },
      "hourly": {
        "time": time,
        "temperature_2m": weather.temperature,
        "apparent_temperature": weather.apparentTemperature,
        "relative_humidity_2m": weather.relativeHumidity,
        "weather_code": weather.weatherCode
      },
    };
  }
}
