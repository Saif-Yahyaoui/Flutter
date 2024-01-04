import 'package:flutter/material.dart';

import '../../../models/Donation.dart';
import '../../../service/DonationApiService.dart';

class EditDonationScreen extends StatelessWidget {
  final Donation donation;
  final VoidCallback onRefresh; // Add this line

  EditDonationScreen({required this.donation, required this.onRefresh});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set initial values for the controllers
    titleController.text = donation.title;
    descriptionController.text = donation.description;
    quantityController.text = donation.quantity.toString();
    dateController.text = donation.date;
    statusController.text = donation.status;

    return AlertDialog(
      title: Text("Edit Donation"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: titleController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            controller: descriptionController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Quantity'),
            controller: quantityController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Date'),
            controller: dateController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Status'),
            controller: statusController,
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
          onPressed: () async {
            // Get the updated data from the controllers
            final String updatedTitle = titleController.text;
            final String updatedDescription = descriptionController.text;
            final int updatedQuantity = int.parse(quantityController.text);
            final String updatedDate = dateController.text;
            final String updatedStatus = statusController.text;

            // Create a map with updated data
            final Map<String, dynamic> updatedData = {
              'title': updatedTitle,
              'description': updatedDescription,
              'quantity': updatedQuantity,
              'date': updatedDate,
              'status': updatedStatus,
            };

            // Call the API to update the donation
            try {
              await DonationApiService(baseUrl: 'http://localhost:7020').updateDonation(donation.iD, updatedData);
              onRefresh(); // Call the callback to refresh the data

              Navigator.of(context).pop();
            } catch (e) {
              print('Failed to update donation: $e');
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
