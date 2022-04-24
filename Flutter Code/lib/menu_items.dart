import 'package:flutter/material.dart';

import 'menu_item.dart';

class MenuItems {
  static const List<MenuItem> profAndSettings = [
    itemProfile,
    itemSettings,
  ];

  static const List<MenuItem> signOut = [
    itemLogOut,
  ];

  static const itemProfile = MenuItem(
    text: 'Profile',
    icon: Icons.person_sharp,
  );

  static const itemSettings = MenuItem(
    text: 'Add Device',
    icon: Icons.settings_sharp,
  );

  static const itemLogOut = MenuItem(
    text: 'Log Out',
    icon: Icons.logout_sharp,
  );
}