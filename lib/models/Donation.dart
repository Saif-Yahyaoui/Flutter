import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class Donation {
  int quantite;
  String date;
  String etat;

  Donation({
    required this.quantite,
    required this.date,
    required this.etat,
  });

  static List<Donation> allDonations = []; // List to store donations

  // Add a method to clear the list
  static void clearDonations() {
    allDonations.clear();
  }
}
