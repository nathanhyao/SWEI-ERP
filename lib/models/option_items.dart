import 'package:flutter/material.dart';
import 'package:shay_app/models/option_item.dart';

class OptionItems {
  static const List<OptionItem> itemsFirst = [
    itemSettings,
    // itemSelectTeam,
    // itemLeaveTeam,
  ];

  static const List<OptionItem> itemsSecond = [
    itemSignOut,
  ];

  static const itemSettings = OptionItem(
    text: 'Settings',
    icon: Icons.settings,
  );

  // static const itemSelectTeam = OptionItem(
  //   text: 'Select Team',
  //   icon: Icons.group,
  // );

  // static const itemLeaveTeam = OptionItem(
  //   text: 'Leave Team',
  //   icon: Icons.group_remove,
  // );

  static const itemSignOut = OptionItem(
    text: 'Sign Out',
    icon: Icons.logout,
  );
}
