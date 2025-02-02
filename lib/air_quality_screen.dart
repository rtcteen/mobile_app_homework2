import 'package:flutter/material.dart';
import 'air_quality_service.dart';

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

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
        title: const Text("Air Quality Index (AQI)", style: TextStyle(fontWeight: FontWeight.bold,),),
        backgroundColor: Color(0xFFDDE6ED),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFFDF6EC),
        child: Center(
          child: aqi == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ชื่อจังหวัด
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // AQI และสถานะ
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: aqiColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "$aqi",
                            style: const TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            airQualityStatus,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // อุณหภูมิ
                    Text(
                      "Temperature: ${temperature?.toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 55),
                    // ปุ่ม Refresh
                    ElevatedButton(
                      onPressed: fetchData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 100, 156, 251),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text(
                        "Refresh",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
