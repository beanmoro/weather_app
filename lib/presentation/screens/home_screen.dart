import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';
import 'package:weather_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'WeatherApp',
      //     style: textTheme.titleLarge,
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.replay_outlined),
      //     )
      //   ],
      // ),
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
            )
          ],
        ),
      ),
    );
  }
}

class _WeatherWeek extends StatelessWidget {
  const _WeatherWeek({
    super.key,
    required this.colors,
    required this.textStyle,
  });

  final ColorScheme colors;
  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                children: [
                  Text('Lun 22', style: textStyle.labelLarge),
                  const Spacer(),
                  Icon(
                    Icons.sunny,
                    color: Colors.orange,
                  ),
                  const Spacer(),
                  Text('5°C', style: textStyle.labelLarge),
                  const Spacer(),
                  Text('18°C', style: textStyle.labelLarge),
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

class _WeatherOnDayByTime extends StatelessWidget {
  const _WeatherOnDayByTime({
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24,
            itemBuilder: (context, index) {
              return _WeatherDaySlide(
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
  });

  final ColorScheme colors;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
            Text('$index:00'),
            const Spacer(),
            const Icon(
              Icons.cloudy_snowing,
              color: Colors.blueGrey,
              size: 32,
            ),
            const Spacer(),
            Text('${20 - index}°C'),
            const Spacer()
          ],
        ),
      ),
    );
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Stack(
          children: [
            CustomGradient(
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
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              const Icon(
                                Icons.sunny,
                                color: Colors.orange,
                                size: 128,
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
