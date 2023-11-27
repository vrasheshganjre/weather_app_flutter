import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/constants/api_key.dart';

class ApiCalls {
  ApiCalls._();

  static getResponse(
      {Position? position,
      String? city,
      String? country,
      String? positionInLatAndLon}) async {
    Map<String, dynamic> queryParameter = {};
    if (position != null) {
      Map? location = await _getLocation(position);

      queryParameter = {"q": "${location!["address"]["city"]}"};
    } else if (city != null) {
      queryParameter = {"q": city};
    } else if (positionInLatAndLon != null) {
      queryParameter = {"q": positionInLatAndLon};
    }
    http.Response response = await http.get(
        Uri.https("api.weatherapi.com", "/v1/current.json", queryParameter),
        headers: {"key": apiKey});

    return jsonDecode(response.body);
  }

  static getForecast(
      {Position? position, String? city, String? positionInLatAndLon}) async {
    Map<String, dynamic> queryParameter = {};
    if (position != null) {
      queryParameter = {
        "q": "${position.latitude},${position.longitude}",
        "days": "14",
        "aqi": "yes",
        "alert": "yes"
      };
    } else if (city != null) {
      queryParameter = {"q": city, "day": "14"};
    } else if (positionInLatAndLon != null) {
      queryParameter = {
        "q": positionInLatAndLon,
        "day": "3",
        "aqi": "yes",
        "alert": "yes"
      };
    }
    try {
      http.Response response = await http.get(
          Uri.https("api.weatherapi.com", "/v1/forecast.json", queryParameter),
          headers: {"key": apiKey});
      return jsonDecode(response.body);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error sending request \nPlease check network connection");
      return false;
    }
  }

  static _getLocation(Position position) async {
    Map<String, dynamic> queryParameter = {
      "lat": "${position.latitude}",
      "lon": "${position.longitude}"
    };
    try {
      http.Response response = await http
          .get(Uri.https("geocode.maps.co", "reverse", queryParameter));
      return jsonDecode(response.body);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error sending request \nPlease check network connection");
      return false;
    }
  }

  static Future<Map> getLocation(String text) async {
    Map<String, dynamic> queryParameter = {
      "namePrefix": text,
      "sort": "-population",
      "types": "CITY",
      "limit": "10"
    };
    http.Response response = await http.get(
        Uri.https(
          "wft-geo-db.p.rapidapi.com",
          "/v1/geo/cities",
          queryParameter,
        ),
        headers: {
          'X-RapidAPI-Key': rapidApiKey,
          'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com'
        });

    return jsonDecode(response.body);
  }
}
// https://wft-geo-db.p.rapidapi.com/v1/geo/cities