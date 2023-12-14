class Donation {
  int quantite;
  String date;
  String etat;


  Donation({
    required this.quantite,
    required this.date,
    required this.etat,
  });

  static List<Donation> allDonations = [];

  static void clearDonations() {
    allDonations.clear();
  }
}
