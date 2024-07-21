import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/infrastructure/repositories/weather_repository_impl.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final weatherRepository = WeatherRepositoryImpl();

  return weatherRepository;
});
