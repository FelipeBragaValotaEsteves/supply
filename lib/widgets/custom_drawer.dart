import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: Colors.green[50],
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                user?.displayName ?? 'Usuário',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                user?.email ?? 'Não autenticado',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.green,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green, 
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.green),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.green[900]),
              ),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(Icons.directions_car, color: Colors.green),
              title: Text(
                'Meus Veículos',
                style: TextStyle(color: Colors.green[900]),
              ),
              onTap: () => Navigator.pushNamed(context, '/vehicles'),
            ),
            ListTile(
              leading: Icon(Icons.add_circle, color: Colors.green),
              title: Text(
                'Adicionar Veículo',
                style: TextStyle(color: Colors.green[900]),
              ),
              onTap: () => Navigator.pushNamed(context, '/add_vehicle'),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.green),
              title: Text(
                'Histórico de Abastecimentos',
                style: TextStyle(color: Colors.green[900]),
              ),
              onTap: () => Navigator.pushNamed(context, '/refuels'),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.green),
              title: Text(
                'Perfil',
                style: TextStyle(color: Colors.green[900]),
              ),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            Divider(color: Colors.green[200]), 
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
