import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/providers/current_provider.dart';
import '../models/current_weather_model.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  void searchWeather() {
    if (cityController.text.isNotEmpty) {
      ref.read(cityProvider.notifier).FetchWeather(cityController.text);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(cityProvider);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;
    final isMediumScreen = size.width >= 400 && size.width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny, color: Colors.amber, size: 24),
            SizedBox(width: 8),
            Text(
              "Weather",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E1A),
              const Color(0xFF1A1F35),
              const Color(0xFF0D1B2A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 8 : 16,
            ),
            child: Column(
              children: [
                _buildSearchBar(isSmallScreen),
                const SizedBox(height: 20),
                Expanded(
                  child: weatherData == null
                      ? _buildEmptyState(isSmallScreen)
                      : _buildWeatherContent(weatherData, isSmallScreen, isMediumScreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: cityController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Search city...",
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: Colors.white54,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              onSubmitted: (value) => searchWeather(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 22),
              onPressed: searchWeather,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 8 : 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Icon(
              Icons.cloud_outlined,
              color: Colors.white.withOpacity(0.3),
              size: isSmallScreen ? 60 : 80,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Weather Forecast",
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 20 : 26,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Search for a city to get started",
            style: TextStyle(
              color: Colors.white60,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(
      CurrentWeatherModel weather,
      bool isSmallScreen,
      bool isMediumScreen,
      ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildMainWeatherCard(weather, isSmallScreen, isMediumScreen),
          const SizedBox(height: 24),
          _buildWeatherStats(weather, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildMainWeatherCard(
      CurrentWeatherModel weather,
      bool isSmallScreen,
      bool isMediumScreen,
      ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${weather.temperature}",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 56 : isMediumScreen ? 72 : 84,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            height: 0.9,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "°C",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 22 : isMediumScreen ? 28 : 32,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.desciptions.isNotEmpty
                          ? weather.desciptions.first.toUpperCase()
                          : "CLEAR",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (weather.icons.isNotEmpty)
                Image.network(
                  weather.icons.first,
                  height: isSmallScreen ? 60 : isMediumScreen ? 80 : 100,
                  width: isSmallScreen ? 60 : isMediumScreen ? 80 : 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: isSmallScreen ? 60 : 80,
                      width: isSmallScreen ? 60 : 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.cloud,
                        color: Colors.white60,
                        size: isSmallScreen ? 30 : 40,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.08),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat(
                icon: Icons.water_drop_outlined,
                label: "Humidity",
                value: "${weather.humidity}%",
                isSmallScreen: isSmallScreen,
              ),
              _buildMiniStat(
                icon: Icons.air,
                label: "Wind",
                value: "${weather.windspeed} km/h",
                isSmallScreen: isSmallScreen,
              ),
              _buildMiniStat(
                icon: Icons.thermostat_outlined,
                label: "Feels Like",
                value: "${weather.feelslike}°C",
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String label,
    required String value,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white60,
          size: isSmallScreen ? 20 : 24,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherStats(CurrentWeatherModel weather, bool isSmallScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: "💧",
            title: "Humidity",
            value: "${weather.humidity}%",
            color: Colors.blue.shade400,
            isSmallScreen: isSmallScreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: "💨",
            title: "Wind Speed",
            value: "${weather.windspeed} km/h",
            color: Colors.green.shade400,
            isSmallScreen: isSmallScreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: "🌡️",
            title: "Feels Like",
            value: "${weather.feelslike}°C",
            color: Colors.orange.shade400,
            isSmallScreen: isSmallScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 16 : 20,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: isSmallScreen ? 28 : 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}