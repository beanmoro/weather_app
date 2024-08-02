import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/config/constants/weather_code_icons.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/presentation/widgets/custom_radial_gradient.dart';
import 'package:weather_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return const Scaffold(
      body: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _CurrentWeather(
              colors: colors,
              textStyles: textStyles,
            ),
            _WeatherOnDayByTime(
              colors: colors,
            ),
            _WeatherWeek(
              colors: colors,
              textStyle: textStyles,
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherWeek extends ConsumerWidget {
  const _WeatherWeek({
    required this.colors,
    required this.textStyle,
  });

  final ColorScheme colors;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);

    // final currentMinIndex =
    //     ref.watch(weatherProvider.notifier).getCurrentMinIndex();

    final tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.2],
            colors: [
              colors.brightness == Brightness.light
                  ? Colors.white
                  : colors.primaryContainer,
              colors.secondaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              color: colors.brightness == Brightness.light
                  ? colors.secondary
                  : Colors.transparent,
              blurRadius: 0.5,
            )
          ],
          color: colors.primaryContainer,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) {
            String currentDay = currentWeatherState.weatherDaily == null
                ? ''
                : DateFormat.E(tag)
                    .add_d()
                    .format(currentWeatherState.weatherDaily!.days[index]);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  (currentWeatherState.weatherDaily == null)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 40, height: 14))
                      : Expanded(
                          child: Text(
                            currentDay,
                            style: textStyle.labelLarge,
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherDaily == null)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 24, height: 24))
                      : Expanded(
                          // child: Icon(
                          //   Icons.sunny,
                          //   color: Colors.orange,
                          // ),
                          child: SvgPicture.asset(
                            WeatherCodeIcons.getIcon(currentWeatherState
                                .weatherDaily!.weatherCode[index]
                                .toInt()),
                            // 'assets/icons/partly_cloudy_day.svg',
                            height: 32,
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherDaily == null)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 20, height: 32))
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                Colors.lightBlue.withOpacity(0.5),
                                colors.primaryContainer.withOpacity(0.1),
                              ]),
                            ),
                            child: Text(
                              '${currentWeatherState.weatherDaily!.minTemperature[index].toInt()}°C',
                              style: textStyle.labelLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  const Spacer(),
                  (currentWeatherState.weatherDaily == null)
                      ? Expanded(
                          child: _ShimmerLoading(
                              colors: colors, width: 20, height: 32))
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              gradient: LinearGradient(colors: [
                                colors.primaryContainer.withOpacity(0.1),
                                Colors.orange.withOpacity(0.75)
                              ]),
                            ),
                            child: Text(
                              '${currentWeatherState.weatherDaily!.maxTemperature[index].toInt()}°C',
                              style: textStyle.labelLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: colors.primary,
              indent: 15,
              endIndent: 15,
              thickness: 0.2,
            );
          },
        ),
      ),
    );
  }
}

class _WeatherOnDayByTime extends ConsumerWidget {
  const _WeatherOnDayByTime({
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);

    final currentMinIndex =
        ref.watch(weatherProvider.notifier).getCurrentMinIndex();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              return _WeatherDaySlide(
                minIndex: currentMinIndex,
                weather: currentWeatherState.weather,
                colors: colors,
                index: index,
              );
            },
          )),
    );
  }
}

class _WeatherDaySlide extends StatelessWidget {
  const _WeatherDaySlide({
    required this.colors,
    required this.index,
    required this.minIndex,
    required this.weather,
  });

  final ColorScheme colors;
  final int index;
  final int minIndex;
  final Weather? weather;

  @override
  Widget build(BuildContext context) {
    // DateTime? currentTime =
    //     DateTime.tryParse(weather!.time[minIndex + index] as String);

    String timeFormatted = weather == null
        ? ''
        : DateFormat.Hm().format(weather!.time[minIndex + index]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.7],
            colors: [
              colors.brightness == Brightness.light
                  ? Colors.white
                  : colors.primaryContainer,
              colors.secondaryContainer
            ],
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              color: colors.brightness == Brightness.light
                  ? colors.secondary
                  : Colors.transparent,
              blurRadius: 0.5,
            )
          ],
          color: colors.primaryContainer,
        ),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            (weather == null)
                ? _ShimmerLoading(colors: colors, width: 40, height: 14)
                : Text(weather == null ? '...' : timeFormatted),
            const Spacer(),
            (weather == null)
                ? _ShimmerLoading(colors: colors, width: 32, height: 32)
                // : const Icon(
                //     Icons.cloudy_snowing,
                //     color: Colors.blueGrey,
                //     size: 32,
                //   ),
                : SvgPicture.asset(
                    // 'assets/icons/partly_cloudy_day.svg',
                    WeatherCodeIcons.getIcon(
                        weather!.weatherCode[minIndex + index]),
                    height: 32,
                  ),
            const Spacer(),
            (weather == null)
                ? _ShimmerLoading(colors: colors, width: 40, height: 14)
                : Text(
                    '${weather == null ? '...' : weather!.temperature[minIndex + index].toInt()}°C'),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading({
    required this.colors,
    required this.width,
    required this.height,
  });

  final ColorScheme colors;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: colors.primary.withOpacity(0.25),
        highlightColor: colors.primary.withOpacity(0.125),
        direction: ShimmerDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey,
          ),
          width: width,
          height: height,
        ));
  }
}

class _CurrentWeather extends ConsumerWidget {
  final ColorScheme colors;
  final TextTheme textStyles;

  const _CurrentWeather({required this.colors, required this.textStyles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeatherState = ref.watch(weatherProvider);

    final currentTemperature =
        ref.watch(weatherProvider.notifier).getCurrentTemperature();

    final currentWeatherCode =
        ref.watch(weatherProvider.notifier).getCurrentWeatherCode();

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            CustomRadialGradient(
              stops: [0.1, 1.0],
              colors: [
                colors.primaryContainer,
                colors.brightness == Brightness.light
                    ? const Color.fromARGB(0, 255, 255, 255)
                    : Colors.transparent
              ],
            ),
            CustomLinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.1, 1.0],
              colors: [
                colors.primaryContainer,
                colors.brightness == Brightness.light
                    ? const Color.fromARGB(0, 255, 255, 255)
                    : Colors.transparent
              ],
            ),
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text(
                              'Quillota',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            icon: const Icon(Icons.location_on),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                ),
                                onPressed: () {},
                                child: Icon(Icons.settings))),
                      ],
                    ),
                    const Spacer(),
                    currentWeatherState.isLoading
                        ? LoadingAnimationWidget.horizontalRotatingDots(
                            color: colors.primary, size: 64)
                        : Column(
                            children: [
                              // const Icon(
                              //   Icons.sunny,
                              //   color: Colors.orange,
                              //   size: 128,
                              // ),
                              SvgPicture.asset(
                                WeatherCodeIcons.getIcon(currentWeatherCode),
                                // 'assets/icons/partly_cloudy_day.svg',
                                height: 128,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$currentTemperature',
                                      style: textStyles.displayLarge),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      '°C',
                                      style: textStyles.headlineSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
