import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {

  final Function()? onTap;
  final Icon icon;
  final String text; 

  const MyListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: onTap,
    );
  }
}