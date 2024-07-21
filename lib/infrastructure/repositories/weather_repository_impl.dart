import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/infrastructure/datasources/weather_datasource_impl.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherDatasource datasource;

  WeatherRepositoryImpl({WeatherDatasource? datasource})
      : datasource = datasource ?? WeatherDatasourceImpl();

  @override
  Future<Weather> getCurrentWeather() {
    return datasource.getCurrentWeather();
  }

  @override
  Future<WeatherDaily> getWeekWeather() {
    return datasource.getWeekWeather();
  }
}
