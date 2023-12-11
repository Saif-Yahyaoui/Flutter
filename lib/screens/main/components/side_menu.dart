
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../donations/donations_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "User",
            svgSrc: "assets/icons/user.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Donations",
            svgSrc: "assets/icons/donation.svg",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonationScreen()),
              );
            },
          ),

          DrawerListTile(
            title: "Auto Collect",
            svgSrc: "assets/icons/autocollect.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Products",
            svgSrc: "assets/icons/products.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Blogs",
            svgSrc: "assets/icons/blogs.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/edit.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/settings.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
