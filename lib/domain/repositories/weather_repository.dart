import '../entities/location.dart';
import '../entities/weather.dart';
import '../entities/weather_daily.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather(Location location);
  Future<WeatherDaily> getWeekWeather(Location location);
}
