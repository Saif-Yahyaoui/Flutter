import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/Donation.dart';
import '../../../constants.dart';
import '../../../service/DonationApiService.dart';
import '../CRUD/add_donations_screen.dart';
import '../CRUD/edit_donation_screen.dart';
import 'donations_info_card.dart';

class Donations extends StatefulWidget {
  final VoidCallback onRefresh;

  const Donations({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _DonationsState createState() => _DonationsState();
}
class _DonationsState extends State<Donations> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                            height: 500,
                            child: AddDonationScreen(
                              onRefresh: widget.onRefresh, // Pass the onRefresh callback
                            ),
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
                childAspectRatio: _size.width < 800 ? 0.8 : 0.8,
                onRefresh: widget.onRefresh, // Pass the onRefresh callback
              ),
              tablet: DonationInfoCardGridView(
                crossAxisCount: _size.width < 1000 ? 3 : 4,
                childAspectRatio: _size.width < 1000 ? 1 : 0.8,
                onRefresh: widget.onRefresh, // Pass the onRefresh callback
              ),
              desktop: DonationInfoCardGridView(
                crossAxisCount: _size.width < 1400 ? 4 : 5,
                childAspectRatio: _size.width < 1400 ? 1 : 0.8,
                onRefresh: widget.onRefresh, // Pass the onRefresh callback
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationInfoCardGridView extends StatefulWidget {
  const DonationInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
     required this.onRefresh,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final VoidCallback onRefresh; // Add this line

  @override
  _DonationInfoCardGridViewState createState() => _DonationInfoCardGridViewState();
}

class _DonationInfoCardGridViewState extends State<DonationInfoCardGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: Donation.allDonations.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => DonationInfoCard(
        info: Donation.allDonations[index],
        onEdit: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditDonationScreen(
                donation: Donation.allDonations[index],
                onRefresh: widget.onRefresh, // Pass the onRefresh callback
              );
            },
          );
        },
        onDelete: () async {
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
                    onPressed: () async {
                      try {
                        await DonationApiService(baseUrl: 'http://localhost:7020')
                            .deleteDonation(Donation.allDonations[index].iD);
                        // Handle the response if needed

                        // Close the dialog
                        Navigator.of(context).pop();
                        // Refresh the UI using the onRefresh callback
                        widget.onRefresh();
                      } catch (e) {
                        print('Failed to delete donation: $e');
                        // Handle the error if needed
                      }
                    },
                    child: Text("Delete"),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
