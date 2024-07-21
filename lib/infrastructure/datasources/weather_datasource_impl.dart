import 'package:weather_app/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/infrastructure/mappers/weather_daily_mapper.dart';
import 'package:weather_app/infrastructure/mappers/weather_mapper.dart';

class WeatherDatasourceImpl extends WeatherDatasource {
  late final Dio dio;

  WeatherDatasourceImpl()
      : dio =
            Dio(BaseOptions(baseUrl: 'https://api.open-meteo.com/v1/forecast'));

  @override
  Future<Weather> getCurrentWeather() async {
    try {
      final response = await dio.get(
          '?latitude=-32.8834&longitude=-71.2488&hourly=temperature_2m,relative_humidity_2m,apparent_temperature&timezone=auto&forecast_days=2');
      final weather = WeatherMapper.jsonToEntity(response.data);
      return weather;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<WeatherDaily> getWeekWeather() async {
    try {
      final response = await dio.get(
          '?latitude=-32.8834&longitude=-71.2488&daily=temperature_2m_max,temperature_2m_min&timezone=auto');

      final weather = WeatherDailyMapper.jsonToEntity(response.data);

      return weather;
    } catch (e) {
      throw Exception();
    }
  }
}
