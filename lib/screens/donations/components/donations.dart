import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/Donation.dart';
import '../../../constants.dart';
import '../CRUD/add_donations_screen.dart';
import '../CRUD/edit_donation.dart';
import 'donations_info_card.dart';

class Donations extends StatelessWidget {
  const Donations({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20), // Adjust the padding as needed
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "List of Donations",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Add New Donation"),
                          content: Container(
                            width: 500,
                            height: 400,
                            child: POST(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add new Donation"),
                ),
              ],
            ),
            SizedBox(height: defaultPadding),
            Responsive(
              mobile: DonationInfoCardGridView(
                crossAxisCount: _size.width < 800 ? 2 : 3,
                childAspectRatio: _size.width < 800 ? 1 : 1,
              ),
              tablet: DonationInfoCardGridView(),
              desktop: DonationInfoCardGridView(
                crossAxisCount: _size.width < 1400 ? 4 : 6,
                childAspectRatio: _size.width < 1400 ? 1 : 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationInfoCardGridView extends StatelessWidget {
  const DonationInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: Donation.allDonations.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => DonationInfoCard(
        info: Donation.allDonations[index],
        onEdit: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditDonationPopup(donation: Donation.allDonations[index]);
            },
          );
        },
        onDelete: () {
          // Handle the delete action, e.g., remove the donation
          Donation.allDonations.removeAt(index);
          // Update the UI by calling setState or updating the data source
          // based on your application architecture.
        },
      ),
    );
  }
}
