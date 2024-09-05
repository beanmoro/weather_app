import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/domain.dart';
import 'package:weather_app/domain/services/geolocation_service.dart';
import 'package:weather_app/infrastructure/mappers/location_mapper.dart';
import 'package:weather_app/infrastructure/mappers/weather_daily_mapper.dart';
import 'package:weather_app/infrastructure/mappers/weather_mapper.dart';
import 'package:weather_app/infrastructure/services/geolocation_service_impl.dart';
import 'package:weather_app/presentation/providers/weather_repository_provider.dart';

enum TempUnit { celsius, fahrenheit }

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
    loadLocalWeather();
    loadWeather();
  }

  Future<void> saveWeatherData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String weatherJson = jsonEncode(WeatherMapper.entityToJson(state.weather!));
    String weatherDailyJson =
        jsonEncode(WeatherDailyMapper.entityToJson(state.weatherDaily!));
    String locationJson =
        jsonEncode(LocationMapper.entityToJson(state.currentLocation!));

    sharedPreferences.setString("weather", weatherJson);
    sharedPreferences.setString("weatherDaily", weatherDailyJson);
    sharedPreferences.setString("location", locationJson);
    sharedPreferences.setString("tempUnit", state.tempUnit.toString());
  }

  Future<void> loadLocalWeather() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? weatherEncoded = sharedPreferences.getString("weather");
      String? weatherDailyEncoded = sharedPreferences.getString("weatherDaily");
      String? locationEncoded = sharedPreferences.getString("location");
      String? tempUnitString = sharedPreferences.getString("tempUnit");

      if (weatherEncoded == null ||
          weatherDailyEncoded == null ||
          locationEncoded == null) {
        if (tempUnitString == null) {
          state = state.copyWith(
            tempUnit: TempUnit.celsius,
          );
        }

        print('>>>>> NO LOCAL DATA FOUND!');
        return;
      }

      Map<String, dynamic> weatherJson = jsonDecode(weatherEncoded);
      Map<String, dynamic> weatherDailyJson = jsonDecode(weatherDailyEncoded);
      Map<String, dynamic> locationJson = jsonDecode(locationEncoded);

      Weather weather = WeatherMapper.jsonToEntity(weatherJson);
      WeatherDaily weatherDaily =
          WeatherDailyMapper.jsonToEntity(weatherDailyJson);
      Location location = LocationMapper.jsonToEntity(locationJson);

      TempUnit tempUnit;
      if (tempUnitString == 'fahrenheit') {
        tempUnit = TempUnit.fahrenheit;
      } else {
        tempUnit = TempUnit.celsius;
      }

      state = state.copyWith(
        isLoading: false,
        weather: weather,
        weatherDaily: weatherDaily,
        currentLocation: location,
        tempUnit: tempUnit,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> loadWeather() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        print('No internet connection!');
        return;
      }

      final location = await getCurrentLocation();

      if (location == null) return;
      final currentWeather =
          await weatherRepository.getCurrentWeather(location);
      final weatherWeek = await weatherRepository.getWeekWeather(location);

      state = state.copyWith(
        isLoading: false,
        weather: currentWeather,
        weatherDaily: weatherWeek,
        currentLocation: location,
      );

      saveWeatherData();
    } catch (e) {
      throw Exception(e);
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
    return state.weather!.weatherCode[index].toInt();
  }

  Future<Location?> getCurrentLocation() async {
    final geolocationPermission =
        await geolocationService.handleLocationPermission();
    if (geolocationPermission != 0) {
      // state = state.copyWith(currentLocation: null, isLoading: true);
      return null;
    }

    final currentPosition = await geolocationService.getCurrentPosition();
    final currentCity =
        await geolocationService.getCurrentCity(currentPosition);
    // state = state.copyWith(
    //   currentLocation:
    //       Location(position: currentPosition, cityName: currentCity!),
    // );
    return Location(position: currentPosition, cityName: currentCity!);
  }

  Future<void> refreshWeather() async {
    state = state.copyWith(isLoading: true);
    loadWeather();
  }

  TempUnit getTempUnit() {
    return state.tempUnit ?? TempUnit.celsius;
  }

  Future<void> setTempUnit(TempUnit tempUnit) async {
    state = state.copyWith(
      tempUnit: tempUnit,
    );
  }
}

class WeatherState {
  final Weather? weather;
  final WeatherDaily? weatherDaily;
  final Location? currentLocation;
  final TempUnit? tempUnit;
  final bool isLoading;

  WeatherState({
    this.weather,
    this.weatherDaily,
    this.currentLocation,
    this.tempUnit,
    this.isLoading = true,
  });

  WeatherState copyWith({
    Weather? weather,
    WeatherDaily? weatherDaily,
    Location? currentLocation,
    TempUnit? tempUnit,
    bool? isLoading,
  }) =>
      WeatherState(
        weather: weather ?? this.weather,
        weatherDaily: weatherDaily ?? this.weatherDaily,
        currentLocation: currentLocation ?? this.currentLocation,
        tempUnit: tempUnit ?? this.tempUnit,
        isLoading: isLoading ?? this.isLoading,
      );
}
