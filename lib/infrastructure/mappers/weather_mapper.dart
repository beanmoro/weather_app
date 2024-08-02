import 'package:weather_app/domain/domain.dart';

class WeatherMapper {
  static Weather jsonToEntity(Map<String, dynamic> json) {
    Map<String, String> hourlyUnits =
        (json['hourly_units'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), value.toString()));

    Map<String, dynamic> hourly = json['hourly'];

    List<DateTime> time = List<DateTime>.from(
        hourly['time'].map((x) => DateTime.tryParse(x.toString())));
    List<double> temperature =
        List<double>.from(hourly['temperature_2m'].map((x) => x));
    List<double> apparentTemperature =
        List<double>.from(hourly['apparent_temperature'].map((x) => x));
    List<int> relativeHumidity =
        List<int>.from(hourly['relative_humidity_2m'].map((x) => x));
    List<int> weatherCode =
        List<int>.from(hourly['weather_code'].map((x) => x));

    return Weather(
      timezone: json['timezone'],
      timezoneAbreviation: json['timezone_abbreviation'],
      hourlyUnits: hourlyUnits,
      time: time,
      temperature: temperature,
      apparentTemperature: apparentTemperature,
      relativeHumidity: relativeHumidity,
      weatherCode: weatherCode,
    );
  }
}
