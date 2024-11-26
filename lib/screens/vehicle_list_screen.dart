import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';
import 'add_vehicle_screen.dart'; 

class VehicleListScreen extends StatefulWidget {
  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late Future<Map<String, dynamic>> _vehiclesFuture;

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = _getVehiclesByUser();
  }

  Future<Map<String, dynamic>> _getVehiclesByUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuário não autenticado.");

    final snapshot = await _database.child('vehicles/${user.uid}').get();
    if (!snapshot.exists) return {};

    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuário não autenticado.");

    await _database.child('vehicles/${user.uid}/$vehicleId').remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Veículos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar veículos: ${snapshot.error}'));
          }

          final vehicles = snapshot.data;

          if (vehicles == null || vehicles.isEmpty) {
            return Center(child: Text('Nenhum veículo encontrado.'));
          }

          return ListView(
            padding: EdgeInsets.all(16),
            children: vehicles.entries.map((entry) {
              final vehicleId = entry.key;
              final vehicle = Map<String, dynamic>.from(entry.value as Map);
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
                    vehicle['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Modelo: ${vehicle['model']} | Placa: ${vehicle['plate']} | Ano: ${vehicle['year']}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddVehicleScreen(
                                vehicleId: vehicleId, 
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              _vehiclesFuture = _getVehiclesByUser();
                            });
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Remover Veículo'),
                                content: Text(
                                    'Tem certeza que deseja remover este veículo?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Remover'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            await _deleteVehicle(vehicleId);
                            setState(() {
                              _vehiclesFuture = _getVehiclesByUser();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Veículo removido com sucesso!')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
