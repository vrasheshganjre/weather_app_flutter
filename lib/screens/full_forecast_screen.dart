import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants/moon_images.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/screens/weather_widget.dart';
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
              height: 650,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 5,
                    child: Text(
                      _getDate(forecast).replaceFirst(" ", "\n"),
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
                    child: Center(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          fields("Avg temp",
                              "${forecast.day!.avgtempC!.round()}℃"),
                          fields("Avg humidity",
                              "${forecast.day!.avghumidity!.round()}%"),
                          fields("Avg visibility",
                              "${forecast.day!.avgvisKm!.round()}km"),
                          fields("Chances of rain",
                              "${forecast.day!.dailyChanceOfRain!.round()}%"),
                          fields("Total precipitation",
                              "${forecast.day!.totalprecipMm!.round()}mm"),
                          fields("UV index", "${forecast.day!.uv!.round()}"),
                          fields("Max Windspeed",
                              "${forecast.day!.maxwindKph!.round()}kmph"),
                          fields("Chances of snow",
                              "${forecast.day!.dailyChanceOfSnow!.round()}%"),
                        ],
                      ),
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
                          fields("Chances of rain",
                              "${hourList[index].chanceOfRain} %"),
                          fields("Humidity", ("${hourList[index].humidity} %")),
                          fields("Pressure",
                              ("${(hourList[index].pressureMb!) / 1000} Bars")),
                          fields("Cloud cover", ("${hourList[index].cloud} %")),
                          fields("Precipitation",
                              ("${hourList[index].precipMm} mm")),
                          fields("UV Index", ("${hourList[index].uv}")),
                          fields("Wind speed",
                              ("${hourList[index].windKph} kmph")),
                          fields(
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
                    fields("Sunrise time", "${forecast.astro!.sunrise}"),
                    fields("Sunset time", "${forecast.astro!.sunset}"),
                    fields("Moonrise time", "${forecast.astro!.moonrise}"),
                    fields("Moon illumination",
                        "${forecast.astro!.moonIllumination} %"),
                    fields("Moonset time", "${forecast.astro!.moonset}"),
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
  final int difference = modelTime.day - currentTime.day;
  if (difference == 0) {
    return "Today";
  } else if (difference == 1) {
    return "Tommorow";
  } else {
    return string;
  }
}
