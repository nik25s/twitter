import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  final String name;
  final IconData icon;
  const DrawerList({Key? key, required this.name, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15),
      child: ListTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 15),
            Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18))
          ],
        ),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    );
  }
}
