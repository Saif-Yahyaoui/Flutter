import 'package:flutter/material.dart';
import '../../../service/DonationApiService.dart';

class AddDonationScreen extends StatefulWidget {
  final VoidCallback onRefresh; 

  const AddDonationScreen({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

TextEditingController title = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController quantity = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController status = TextEditingController();

class _AddDonationScreenState extends State<AddDonationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: quantity,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: date,
              decoration: const InputDecoration(labelText: "Date"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: status,
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var data = {
                  "title": title.text,
                  "description": description.text,
                  "quantity": quantity.text,
                  "date": date.text,
                  "status": status.text,
                };

                try {
                  await DonationApiService(baseUrl: 'http://localhost:7020').createDonation(data);
                  print('Donation created successfully');
                  widget.onRefresh(); // Call the callback to refresh the data

                  Navigator.pop(context); // Pop the current route
                } catch (e) {
                  print('Failed to create donation: $e');
                }
              },
              child: const Text("POST"),
            )
          ],
        ),
      ),
    );
  }
}
