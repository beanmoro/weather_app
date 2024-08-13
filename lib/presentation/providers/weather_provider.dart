import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/domain/entities/location.dart';
import 'package:weather_app/domain/services/geolocation_service.dart';
import 'package:weather_app/infrastructure/services/geolocation_service_impl.dart';
import 'package:weather_app/presentation/providers/weather_repository_provider.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);

  return WeatherNotifier(weatherRepository: weatherRepository);
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository weatherRepository;
  final GeolocationService geolocationService;

  WeatherNotifier({required this.weatherRepository})
      : geolocationService = GeolocationServiceImpl(),
        super(WeatherState()) {
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      await getCurrentLocation();

      final currentWeather =
          await weatherRepository.getCurrentWeather(state.currentLocation!);
      final weatherWeek =
          await weatherRepository.getWeekWeather(state.currentLocation!);
      state = state.copyWith(
        isLoading: false,
        weather: currentWeather,
        weatherDaily: weatherWeek,
      );
    } catch (e) {
      throw Exception();
    }
  }

  int _findClosestTimeIndex(List<DateTime> time) {
    DateTime now = DateTime.now();
    int closestIndex = 0;
    Duration smallestDifference = now.difference(time[0]).abs();

    for (int i = 0; i < time.length; i++) {
      Duration difference = now.difference(time[i]).abs();
      if (difference < smallestDifference) {
        smallestDifference = difference;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  int getCurrentTemperature() {
    if (state.weather == null) return 999;
    int index = getCurrentMinIndex();
    return state.weather!.temperature[index].toInt();
  }

  int getCurrentMinIndex() {
    if (state.weather == null) return 999;
    int index = _findClosestTimeIndex(state.weather!.time);
    return index;
  }

  int getCurrentWeatherCode() {
    if (state.weather == null) return -1;
    int index = getCurrentMinIndex();
    print('>>> ${state.weather!.weatherCode[index].toInt()}');
    return state.weather!.weatherCode[index].toInt();
  }

  Future<void> getCurrentLocation() async {
    final geolocationPermission =
        await geolocationService.handleLocationPermission();
    if (geolocationPermission != 0) {
      state = state.copyWith(currentLocation: null, isLoading: true);
      return;
    }

    final currentPosition = await geolocationService.getCurrentPosition();
    final currentCity =
        await geolocationService.getCurrentCity(currentPosition);
    state = state.copyWith(
      currentLocation:
          Location(position: currentPosition, cityName: currentCity!),
    );
  }

  Future<void> refreshWeather() async {
    state = state.copyWith(isLoading: true);
    loadWeather();
  }
}

class WeatherState {
  final Weather? weather;
  final WeatherDaily? weatherDaily;
  final Location? currentLocation;
  final bool isLoading;

  WeatherState({
    this.weather,
    this.weatherDaily,
    this.currentLocation,
    this.isLoading = true,
  });

  WeatherState copyWith({
    Weather? weather,
    WeatherDaily? weatherDaily,
    Location? currentLocation,
    bool? isLoading,
  }) =>
      WeatherState(
        weather: weather ?? this.weather,
        weatherDaily: weatherDaily ?? this.weatherDaily,
        currentLocation: currentLocation ?? this.currentLocation,
        isLoading: isLoading ?? this.isLoading,
      );
}
