import '../entities/weather.dart';
import '../entities/weather_daily.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather();
  Future<WeatherDaily> getWeekWeather();
}
