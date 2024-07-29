import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/presentation/providers/weather_repository_provider.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);

  return WeatherNotifier(weatherRepository: weatherRepository);
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherNotifier({required this.weatherRepository}) : super(WeatherState()) {
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      final currentWeather = await weatherRepository.getCurrentWeather();
      final weatherWeek = await weatherRepository.getWeekWeather();
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
}

class WeatherState {
  final Weather? weather;
  final WeatherDaily? weatherDaily;
  final bool isLoading;

  WeatherState({
    this.weather,
    this.weatherDaily,
    this.isLoading = true,
  });

  WeatherState copyWith({
    Weather? weather,
    WeatherDaily? weatherDaily,
    bool? isLoading,
  }) =>
      WeatherState(
        weather: weather ?? this.weather,
        weatherDaily: weatherDaily ?? this.weatherDaily,
        isLoading: isLoading ?? this.isLoading,
      );
}
