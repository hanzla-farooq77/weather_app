import 'package:flutter_riverpod/legacy.dart';
import 'package:notes_app/models/current_weather_model.dart';
import 'package:notes_app/services/weather_service.dart';

final cityProvider =
    StateNotifierProvider<weatherNotifier, CurrentWeatherModel?>((ref) {
      return weatherNotifier();
    });

class weatherNotifier extends StateNotifier<CurrentWeatherModel?> {
  weatherNotifier() : super(null);
  final WeatherService service = WeatherService();
  Future<void> FetchWeather(String city) async {
    try {
      final weather = service.getCurrent(city);
      state = await weather;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
