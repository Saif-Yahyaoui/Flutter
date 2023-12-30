import 'package:admin/models/Donation.dart';
import 'package:flutter/material.dart';

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
                  onTap: onDelete,
                  child: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ),
          DonationInfoRow(
              label: 'Title:',
              value: info.title.toString()
          ),
          DonationInfoRow(
            label: 'Description:',
            value: info.description.toString(),
            maxLines: 1,
          ),
          DonationInfoRow(
              label: 'Quantity:',
              value: info.quantity.toString()
          ),
          DonationInfoRow(
              label: 'Date:',
              value: info.date.toString()
          ),
          DonationInfoRow(
              label: 'Status:',
              value: info.status.toString()
          ),
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
    this.maxLines = 1,
  }) : super(key: key);

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
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
