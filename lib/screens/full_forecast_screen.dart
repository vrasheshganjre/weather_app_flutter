import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants/moon_images.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/theme/custom_styles.dart';

class FullForecastScreen extends GetView<HomeController> {
  const FullForecastScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Full Forecast"),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final forecast = controller.forecastModel.value;
            return SingleChildScrollView(
                child: Column(
              children: List.generate(
                forecast.forecast!.forecastday!.length,
                (index) => ListTile(
                    title:
                        Text(_getDate(forecast.forecast!.forecastday![index])),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ForecastWidget(
                                  location:
                                      controller.currentLocation.value.name!,
                                  forecast:
                                      forecast.forecast!.forecastday![index]))),
                        )),
              ),
            ));
          }
        }),
      );
}

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    super.key,
    required this.forecast,
    required this.location,
  });

  final Forecastday forecast;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: Get.width,
              height: 500,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 5,
                    child: Text(
                      _getDate(forecast).replaceFirst(" ", "to"),
                      style: heading1(),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${forecast.day!.maxtempC!.round()}℃",
                          style: const TextStyle(fontSize: 60),
                        ),
                        Text(
                          "${forecast.day!.mintempC!.round()}℃",
                          style:
                              const TextStyle(fontSize: 30, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 170,
                    right: 5,
                    left: 5,
                    child: Column(
                      children: [
                        Image.asset(
                          forecast.day!.condition!.icon!.replaceFirst(
                              "//cdn.weatherapi.com/weather/64x64",
                              "assets/images"),
                        ),
                        Text(
                          forecast.day!.condition!.text!,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Avg temp"),
                                Text("${forecast.day!.avgtempC!.round()}℃")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Avg humidity"),
                                Text("${forecast.day!.avghumidity!.round()}%")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Avg visibility"),
                                Text("${forecast.day!.avgvisKm!.round()}km")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Chances of rain"),
                                Text(
                                    "${forecast.day!.dailyChanceOfRain!.round()}%")
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total precipitation"),
                                Text(
                                    "${forecast.day!.totalprecipMm!.round()}mm")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("UV index"),
                                Text("${forecast.day!.uv!.round()}")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Max Windspeed"),
                                Text("${forecast.day!.maxwindKph!.round()}kmph")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Chances of snow"),
                                Text(
                                    "${forecast.day!.dailyChanceOfSnow!.round()}%")
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Weather forecast by hours",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(forecast.hour!.length, (index) {
                  final hourList = forecast.hour!;
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      child: Column(
                        children: [
                          Text(DateFormat("jm").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  hourList[index].timeEpoch! * 1000))),
                          Image.asset(hourList[index]
                              .condition!
                              .icon!
                              .replaceFirst(
                                  "//cdn.weatherapi.com/weather/64x64",
                                  "assets/images")),
                          Text(hourList[index].condition!.text!),
                          Text("${hourList[index].tempC!.round()}℃"),
                          _fields("Chances of rain",
                              "${hourList[index].chanceOfRain} %"),
                          _fields(
                              "Humidity", ("${hourList[index].humidity} %")),
                          _fields("Pressure",
                              ("${(hourList[index].pressureMb!) / 1000} Bars")),
                          _fields(
                              "Cloud cover", ("${hourList[index].cloud} %")),
                          _fields("Precipitation",
                              ("${hourList[index].precipMm} mm")),
                          _fields("UV Index", ("${hourList[index].uv}")),
                          _fields("Wind speed",
                              ("${hourList[index].windKph} kmph")),
                          _fields(
                              "Wind direction", ("${hourList[index].windDir}")),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Astro details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sunrise time"),
                        Text("${forecast.astro!.sunrise}")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sunset time"),
                        Text("${forecast.astro!.sunset}")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Moonrise time"),
                        Text("${forecast.astro!.moonrise}")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Moon illumination"),
                        Text("${forecast.astro!.moonIllumination} %")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Moonset time"),
                        Text("${forecast.astro!.moonset}")
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Moon Phase",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          moonImages[forecast.astro!.moonPhase!],
                          style: const TextStyle(fontSize: 150),
                        ),
                        Text(forecast.astro!.moonPhase!,
                            style: const TextStyle(fontSize: 40)),
                      ],
                    )
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

String _getDate(Forecastday forecast) {
  final currentTime = DateTime.now();

  final modelTime = DateTime.fromMillisecondsSinceEpoch(
      forecast.dateEpoch! * 1000,
      isUtc: true);
  final string = DateFormat("dd MMMM").format(modelTime);
  final model = "${modelTime.day}-${modelTime.month}-${modelTime.year}";
  final int difference = modelTime.day - currentTime.day;
  if (difference == 0) {
    return "Today";
  } else if (difference == 1) {
    return "Tommorow";
  } else {
    return string;
  }
}

Widget _fields(String heading, String value) => Container(
      padding: const EdgeInsets.all(10),
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(heading), Text(value)],
      ),
    );
