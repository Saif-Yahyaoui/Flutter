import 'package:admin/screens/donations/add_donations_screen.dart';
import 'package:flutter/material.dart';
import '../../service/DonationApiService.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final DonationApiService apiService = DonationApiService(baseUrl: 'http://localhost:7001');
  late Future<List<Map<String, dynamic>>> donations;

  @override
  void initState() {
    super.initState();
    donations = apiService.getAllDonations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donations'),
          actions: [
            // Button in the app bar on the right
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => POST()),
                  );                },
                child: Text('Add Donations'),
              ),
            ),
          ],
        ),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${snapshot.data![index]['quantite']}'),
                        Text('Date: ${snapshot.data![index]['date']}'),
                        Text('Status: ${snapshot.data![index]['etat']}'),
                        // Add more fields as needed
                      ],
                    ),
                    // Add more features to the ListTile if required
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
