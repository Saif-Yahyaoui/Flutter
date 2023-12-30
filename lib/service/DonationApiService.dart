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
  Future<void> updateDonation(String donationId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/donation/$donationId'), // Assuming this is the correct endpoint for updating a donation
        body: jsonEncode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Donation updated successfully: $responseData');
      } else {
        print('Failed to update donation');
        throw Exception('Failed to update donation');
      }
    } catch (e) {
      print('Error updating donation: $e');
      throw Exception('Error updating donation');
    }
  }

  Future<void> deleteDonation(String donationId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/donation/$donationId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Donation deleted successfully: $responseData');
      } else {
        print('Failed to delete donation');
        throw Exception('Failed to delete donation');
      }
    } catch (e) {
      print('Error deleting donation: $e');
      throw Exception('Error deleting donation');
    }
  }

}



