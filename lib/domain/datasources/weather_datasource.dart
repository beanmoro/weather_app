import '../entities/weather.dart';
import '../entities/weather_daily.dart';

abstract class WeatherDatasource {
  Future<Weather> getCurrentWeather();
  Future<WeatherDaily> getWeekWeather();
}
