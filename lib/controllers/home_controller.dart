import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/api/api_calls.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';

class HomeController extends GetxController {
  final textController = TextEditingController();
  final currentWeather = WeatherModel().obs;
  final currentLocation = LocationModel().obs;
  final forecastModel = ForecastModel().obs;
  final isLoading = true.obs;
  final suggestions = [].obs;
  final darkMode = false.obs;

  @override
  void onReady() {
    super.onReady();
    getCurrentLocationData();
    getLocationSuggestions();
    darkMode.value = Get.isDarkMode;
  }

  Future<void> getCurrentLocationData() async {
    isLoading.value = true;
    final locationPermission = await _getLocationPermission();

    if (locationPermission) {
      final position = await Geolocator.getCurrentPosition();

      var location = await ApiCalls.getForecast(position: position);
      location != null
          ? textController.text =
              "${location["location"]["name"] ?? ""}, ${location["location"]["region"]}, ${location["location"]["country"]}"
          : null;
      forecastModel.value = ForecastModel.fromJson(location);
      currentLocation.value = LocationModel.fromJson(location["location"]);
      isLoading.value = false;
    }
  }

  getWeather() async {
    isLoading.value = true;
    var weather = await ApiCalls.getResponse(
        positionInLatAndLon:
            "${currentLocation.value.lat},${currentLocation.value.lon}");
    currentWeather.value = WeatherModel.fromJson(weather["current"]);
    isLoading.value = false;
  }

  _getLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: "Please enable location services on this device.");
      return false;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Please allow location permission");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Please allow location permission");
      return false;
    }
    return true;
  }

  Future<void> getLocationSuggestions() async {
    var result = await ApiCalls.getLocation(textController.text);
    try {
      suggestions.value = result["data"];
    } catch (e) {
      Fluttertoast.showToast(msg: "e");
    }
  }

  void changeTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    darkMode.value = !darkMode.value;
  }

  Future<void> getForecast() async {
    isLoading.value = true;
    final result = await ApiCalls.getForecast(
        positionInLatAndLon:
            "${currentLocation.value.lat},${currentLocation.value.lon}");
    forecastModel.value = ForecastModel.fromJson(result);
    isLoading.value = false;
  }
}
