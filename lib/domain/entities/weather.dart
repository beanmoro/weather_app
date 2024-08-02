class Weather {
  final String timezone;
  final String timezoneAbreviation;
  final Map<String, String> hourlyUnits;
  final List<DateTime> time;
  final List<double> temperature;
  final List<double> apparentTemperature;
  final List<int> relativeHumidity;
  final List<int> weatherCode;

  Weather({
    required this.timezone,
    required this.timezoneAbreviation,
    required this.hourlyUnits,
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.weatherCode,
  });
}
