import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simpleweather/domain/domain.dart';
import 'package:simpleweather/infrastructure/repositories/weather_repository_impl.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final weatherRepository = WeatherRepositoryImpl();

  return weatherRepository;
});
