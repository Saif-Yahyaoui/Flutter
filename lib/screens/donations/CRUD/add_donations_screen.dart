import 'package:flutter/material.dart';
import '../../../service/DonationApiService.dart';

class POST extends StatefulWidget {
  const POST({super.key});

  @override
  State<POST> createState() => _POSTState();
}

TextEditingController quantite = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController etat = TextEditingController();

class _POSTState extends State<POST> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: quantite,
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
              controller: etat,
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var data = {
                  "quantite": quantite.text,
                  "date": date.text,
                  "etat": etat.text,
                };

                try {
                  await DonationApiService(baseUrl: 'http://localhost:7001').createDonation(data);
                  // Mobile host 10.0.2.2
                  print('Donation created successfully');
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

