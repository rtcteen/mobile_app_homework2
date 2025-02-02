import 'package:http/http.dart' as http;
import 'dart:convert';

class AirQualityService {
  final String apiUrl =
      'https://api.waqi.info/feed/here/?token=7065ec7544c5348dd681fbe23186d353df2f075b'; // แทนที่ YOUR_API_TOKEN

  Future<Map<String, dynamic>?> fetchAirQuality() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 100) {
        final data = json.decode(response.body);
        return {
          'aqi': data['data']['aqi'],
          'city': data['data']['city']['name'],
          'temperature': data['data']['iaqi']['t']['v'].toDouble(),
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
