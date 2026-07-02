class CurrentWeatherModel {
  final int temperature;
  final int windspeed;
  final int humidity;
  final int feelslike;
  final List<String> desciptions;
  final List<String> icons;

  CurrentWeatherModel({
    required this.desciptions,
    required this.feelslike,
    required this.humidity,
    required this.icons,
    required this.temperature,
    required this.windspeed,
  });
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      desciptions: List<String>.from(json["weather_descriptions"]),

      feelslike: json["feelslike"],

      humidity: json["humidity"],

      icons: List<String>.from(json["weather_icons"]),

      temperature: json["temperature"],

      windspeed: json["wind_speed"],
    );
  }
}
