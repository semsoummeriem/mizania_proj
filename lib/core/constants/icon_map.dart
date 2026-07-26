import "package:flutter/material.dart";

Map<String, IconData> dbmap = {
  'home': Icons.home,
  'card_giftcard': Icons.card_giftcard,
  'fastfood': Icons.fastfood,
  'calendar_today': Icons.calendar_today,
  'directions_car': Icons.directions_car,
  'local_pharmacy': Icons.local_pharmacy,
  'sports_esports': Icons.sports_esports,
  'category': Icons.category,
};

//function to fetch the correct icn name from db

String renameIcon(IconData icon) {
  return dbmap.entries.firstWhere((e) => e.value == icon).key;
}

IconData iconname(String name) {
  return dbmap[name] ?? Icons.category;
}
