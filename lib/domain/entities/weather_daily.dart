class WeatherDaily {
  final String timezone;
  final String timezoneAbreviation;
  final Map<String, String> dailyUnits;
  final List<DateTime> days;
  final List<double> minTemperature;
  final List<double> maxTemperature;
  final List<int> weatherCode;

  WeatherDaily({
    required this.timezone,
    required this.timezoneAbreviation,
    required this.dailyUnits,
    required this.days,
    required this.minTemperature,
    required this.maxTemperature,
    required this.weatherCode,
  });
}
