import 'package:simpleweather/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:simpleweather/infrastructure/mappers/weather_daily_mapper.dart';
import 'package:simpleweather/infrastructure/mappers/weather_mapper.dart';

class WeatherDatasourceImpl extends WeatherDatasource {
  late final Dio dio;

  WeatherDatasourceImpl()
      : dio =
            Dio(BaseOptions(baseUrl: 'https://api.open-meteo.com/v1/forecast'));

  @override
  Future<Weather> getCurrentWeather(Location location) async {
    try {
      final response = await dio.get(
          '?latitude=${location.position.latitude}&longitude=${location.position.longitude}&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code&timezone=auto&forecast_days=3');
      final weather = WeatherMapper.jsonToEntity(response.data);
      return weather;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<WeatherDaily> getWeekWeather(Location location) async {
    try {
      final response = await dio.get(
          '?latitude=${location.position.latitude}&longitude=${location.position.longitude}&daily=temperature_2m_max,temperature_2m_min,weather_code&timezone=auto');

      final weather = WeatherDailyMapper.jsonToEntity(response.data);

      return weather;
    } catch (e) {
      throw Exception();
    }
  }
}
