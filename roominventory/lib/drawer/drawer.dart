import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/eventos/eventos.dart'; // Import Cupertino icons
import '/itens/itens.dart';
import '/locais/locais.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(),
          ListTile(
            leading: Icon(CupertinoIcons.calendar),
            title: Text('Eventos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventosPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.cube_box),
            title: Text('Itens'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.map_pin),
            title: Text('Locais'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LocaisPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
