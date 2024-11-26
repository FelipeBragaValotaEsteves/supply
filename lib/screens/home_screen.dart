import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_list_screen.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supply', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      drawer: CustomDrawer(),
      body: Container(
        color: Colors.white, 
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Supply App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, 
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bem-vindo, ${user?.displayName ?? 'Usuário'}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, 
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddVehicleScreen()),
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                      size: 80, 
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Adicionar Veículo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VehicleListScreen()),
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Colors.green,
                      size: 80, 
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ver Lista de Veículos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Informações'),
                        content: Text(
                          'Versão: 1.0.0\n'
                          'Todos os direitos reservados.\n'
                          '© 2024 Supply App',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Fechar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green,
                      size: 80,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Informações',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
