import 'dart:convert';
import 'package:http/http.dart' as http;

class DonationApiService {
  final String baseUrl;

  DonationApiService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> getAllDonations() async {
    final response = await http.get(Uri.parse('$baseUrl/donation/donations'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> donations =
      data.cast<Map<String, dynamic>>();
      return donations;
    } else {
      throw Exception('Failed to load donations');
    }
  }

  Future<void> createDonation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donation/donations'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print(responseData);
      } else {
        print('Failed to create donation');
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
