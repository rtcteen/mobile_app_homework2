import 'package:flutter/material.dart';
import 'air_quality_service.dart';

class AirQualityScreen extends StatefulWidget {
  @override
  _AirQualityScreenState createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  final AirQualityService airQualityService = AirQualityService();
  int? aqi;
  String city = "";
  double? temperature;
  String airQualityStatus = "";
  Color aqiColor = Colors.grey;

  Future<void> fetchData() async {
    final data = await airQualityService.fetchAirQuality();
    if (data != null) {
      setState(() {
        aqi = data['aqi'];
        city = data['city'];
        temperature = data['temperature'];
        setAirQualityStatus(aqi!);
      });
    }
  }

  void setAirQualityStatus(int aqi) {
    if (aqi <= 50) {
      airQualityStatus = "Good";
      aqiColor = Colors.green;
    } else if (aqi <= 100) {
      airQualityStatus = "Moderate";
      aqiColor = Colors.yellow;
    } else if (aqi <= 150) {
      airQualityStatus = "Unhealthy for Sensitive Groups";
      aqiColor = Colors.orange;
    } else if (aqi <= 200) {
      airQualityStatus = "Unhealthy";
      aqiColor = Colors.red;
    } else if (aqi <= 300) {
      airQualityStatus = "Very Unhealthy";
      aqiColor = Colors.purple;
    } else {
      airQualityStatus = "Hazardous";
      aqiColor = Colors.brown;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Air Quality Index (AQI)"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: aqi == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    city,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: aqiColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "$aqi",
                      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    airQualityStatus,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: aqiColor),
                  ),
                  Text(
                    "Temperature: ${temperature?.toStringAsFixed(1)}°C",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Refresh"),
                  ),
                ],
              ),
      ),
    );
  }
}
