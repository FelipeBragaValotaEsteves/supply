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
        title: Text('Controle de Abastecimento', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, 
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade400], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.local_gas_station,
                color: Colors.white,
                size: 80, 
              ),
              SizedBox(height: 20),
              Text(
                'Bem-vindo, ${user?.email ?? "Usuário"}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddVehicleScreen()), 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text('Adicionar Veículo', style: TextStyle(color: Colors.green))
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VehicleListScreen()), 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                ),
                child: Text('Ver Lista de Veículos', style: TextStyle(color: Colors.green))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
