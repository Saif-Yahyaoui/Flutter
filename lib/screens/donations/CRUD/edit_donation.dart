import 'package:flutter/material.dart';

import '../../../models/Donation.dart';
import '../../../service/DonationApiService.dart';

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
          onPressed: ()  {
            // Get the updated data from the controllers


            // Create a map with updated data

            // Call the API to update the donation

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),

      ],
    );
  }
}
