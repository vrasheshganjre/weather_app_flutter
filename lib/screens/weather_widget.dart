import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/screens/full_forecast_screen.dart';
import 'package:weather_app/theme/custom_styles.dart';

class WeatherWidget extends GetView<HomeController> {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentWeather = controller.forecastModel.value.current!;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                controller.forecastModel.value.location!.name!,
                style: heading1(),
              ),
              Image.asset(
                currentWeather.condition!.icon!.replaceFirst(
                    "//cdn.weatherapi.com/weather/64x64", "assets/images"),
              ),
              Text(currentWeather.condition!.text!),
              Text(
                "${currentWeather.tempC!.round()}\u2103",
                style: const TextStyle(fontSize: 40),
              ),
              Text(
                "Feels like ${currentWeather.feelslikeC!.round()}\u2103",
              ),
              _fields("Humidity",
                  ("${controller.forecastModel.value.current!.humidity} %")),
              _fields("Pressure",
                  ("${(controller.forecastModel.value.current!.pressureMb!) / 1000} Bars")),
              _fields("Cloud cover",
                  ("${controller.forecastModel.value.current!.cloud} %")),
              _fields("Precipitation",
                  ("${controller.forecastModel.value.current!.precipMm} mm")),
              _fields("UV Index",
                  ("${controller.forecastModel.value.current!.uv}")),
              _fields("Wind speed",
                  ("${controller.forecastModel.value.current!.windKph} kmph")),
              _fields("Wind direction",
                  ("${controller.forecastModel.value.current!.windDir}")),
              const Text(
                "AQI",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              _fields("CO",
                  ("${controller.forecastModel.value.current!.airQuality!["co"]} μg/㎥")),
              _fields("O₃",
                  ("${controller.forecastModel.value.current!.airQuality!["o3"]} μg/㎥")),
              _fields("NO₂",
                  ("${controller.forecastModel.value.current!.airQuality!["no2"]} μg/㎥")),
              _fields("SO₂",
                  ("${controller.forecastModel.value.current!.airQuality!["so2"]} μg/㎥")),
              _fields("PM2.5",
                  ("${controller.forecastModel.value.current!.airQuality!["pm2_5"]} μg/㎥")),
              _fields("PM10",
                  ("${controller.forecastModel.value.current!.airQuality!["pm10"]} μg/㎥")),
              _fields("US - EPA standard",
                  ("${controller.forecastModel.value.current!.airQuality!["us-epa-index"]}")),
              _fields("UK Defra Index",
                  ("${controller.forecastModel.value.current!.airQuality!["gb-defra-index"]}")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FullForecastScreen()));
                  },
                  child: const Text("See full forecast"))
            ],
          ),
        ),
      );
    });
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
