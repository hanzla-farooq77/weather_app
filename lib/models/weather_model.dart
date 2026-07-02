import 'current_weather_model.dart';
import 'location_model.dart';

class WeatherModel {

  final LocationModel location;
  final CurrentWeatherModel current;


  WeatherModel({
    required this.location,
    required this.current,
  });


  factory WeatherModel.fromJson(Map<String,dynamic> json){

    return WeatherModel(

      location: LocationModel.fromJson(
          json["location"]
      ),

      current: CurrentWeatherModel.fromJson(
          json["current"]
      ),

    );

  }

}