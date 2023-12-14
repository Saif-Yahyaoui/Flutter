import 'package:admin/models/Donation.dart';
import 'package:admin/models/MyFiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class DonationInfoCard extends StatelessWidget {
  const DonationInfoCard({
    Key? key,
    required this.info,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final Donation info;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: onEdit,
                  child: Icon(Icons.edit, color: Colors.lightGreen),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    // Show a confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Donation"),
                          content: Text("Are you sure you want to delete this donation?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                onDelete(); // Call the onDelete callback
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ),
          DonationInfoRow(label: 'Quantity:', value: info.quantite.toString()),
          DonationInfoRow(label: 'Date:', value: info.date.toString()),
          DonationInfoRow(label: 'Status:', value: info.etat.toString()),
        ],
      ),
    );
  }
}



class DonationInfoRow extends StatelessWidget {
  const DonationInfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        LayoutBuilder(
          builder: (context, constraints) => Container(
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
