import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';  

class VehicleListScreen extends StatelessWidget {
  Future<List<Vehicle>> _getVehicles() async {
    final vehicleCollection = FirebaseFirestore.instance.collection('vehicles');
    final snapshot = await vehicleCollection.get();
    return snapshot.docs.map((doc) {
      return Vehicle(
        id: doc.id,
        name: doc['name'],
        model: doc['model'],
        year: doc['year'],
        plate: doc['plate'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Veículos'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: _getVehicles(),  
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar veículos: ${snapshot.error}'));
          }

          final vehicles = snapshot.data;

          if (vehicles == null || vehicles.isEmpty) {
            return Center(child: Text('Nenhum veículo encontrado.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.car_repair, color: Colors.green),
                    title: Text(
                      vehicle.name,  
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      'Modelo: ${vehicle.model} | Placa: ${vehicle.plate} | Ano: ${vehicle.year}',
                      style: TextStyle(color: Colors.black54),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.green),
                    onTap: () {
                      print('Clicou no veículo: ${vehicle.name}');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
