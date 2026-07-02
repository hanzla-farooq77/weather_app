class LocationModel {
  final String name;
  final String country;
  final String region;
  final String timezone;
  final String localTime;

  LocationModel({
    required this.name,
    required this.country,
    required this.region,
    required this.timezone,
    required this.localTime,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json["name"],

      country: json["country"],

      region: json["region"],

      timezone: json["timezone_id"],

      localTime: json["localtime"],
    );
  }
}
