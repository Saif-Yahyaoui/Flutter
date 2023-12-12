import 'package:flutter/material.dart';

import '../../models/Donation.dart';

class EditDonationPopup extends StatelessWidget {
  final Donation donation;

  EditDonationPopup({required this.donation});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Donation"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Quantity'),
            controller: TextEditingController(text: donation.quantite.toString()),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Date'),
            controller: TextEditingController(text: donation.date),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Status'),
            controller: TextEditingController(text: donation.etat),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Update the donation here using the API service
            // Update the fields based on the text controllers
            // DonationApiService().updateDonation(updatedDonation);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
