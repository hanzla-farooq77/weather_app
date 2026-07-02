import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/constants/api_constant.dart';
import 'package:notes_app/models/current_weather_model.dart';

class WeatherService {

  Future<CurrentWeatherModel> getCurrent(String city) async {
    
    final currentUrl = Uri.parse(
      "${ApiConstant.baseURL}${ApiConstant.currentEndpoint}"
          "?access_key=${ApiConstant.apiKey}&query=$city",
    );

    final response = await http.get(currentUrl);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      if (data['success'] == false) {
        throw Exception(data['error']['info']);
      }

      return CurrentWeatherModel.fromJson(data['current']);

    } else {
      throw Exception('Failed to fetch weather');
    }
  }
}