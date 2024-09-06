import 'package:simpleweather/domain/domain.dart';
import 'package:simpleweather/infrastructure/datasources/weather_datasource_impl.dart';

import '../../domain/entities/location.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final WeatherDatasource datasource;

  WeatherRepositoryImpl({WeatherDatasource? datasource})
      : datasource = datasource ?? WeatherDatasourceImpl();

  @override
  Future<Weather> getCurrentWeather(Location location) {
    return datasource.getCurrentWeather(location);
  }

  @override
  Future<WeatherDaily> getWeekWeather(Location location) {
    return datasource.getWeekWeather(location);
  }
}
