import 'package:admin/screens/donations/CRUD/add_donations_screen.dart';
import 'package:admin/screens/donations/components/donations.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/Donation.dart';
import '../../service/DonationApiService.dart';
import '../dashboard/components/header.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final DonationApiService apiService = DonationApiService(baseUrl: 'http://localhost:7020');
  late Future<List<Map<String, dynamic>>> donations;

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    setState(() {
      donations = apiService.getAllDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: donations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No donations available.');
            } else {
              Donation.clearDonations();
              snapshot.data!.forEach((donation) {
                Donation.allDonations.add(Donation(
                  id: donation['id'] ?? '',
                  title: donation['title'] ?? '',
                  description: donation['description'] ?? '',
                  quantity: donation['quantity'] ?? 0,
                  date: donation['date'] ?? '',
                  status: donation['status'] ?? '',
                ));
              });

              return Donations(
                onRefresh: fetchDonations, // Pass the function to refresh the data
              );
            }
          },
        ),
      ),
    );
  }
}
