import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_drawer.dart';

class RefuelHistoryScreen extends StatefulWidget {
  @override
  _RefuelHistoryScreenState createState() => _RefuelHistoryScreenState();
}

class _RefuelHistoryScreenState extends State<RefuelHistoryScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String? selectedVehicleId;
  List<Map<String, dynamic>> refuels = [];
  List<Map<String, dynamic>> vehicles = [];
  double? averageConsumption;

  @override
  void initState() {
    super.initState();
    _getVehicles();
  }

  Future<void> _getVehicles() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário não autenticado")),
      );
      return;
    }

    try {
      final vehiclesSnapshot = await _database.child('vehicles/$userId').get();

      if (!vehiclesSnapshot.exists) {
        setState(() {
          vehicles = [];
        });
        return;
      }

      final vehiclesList = <Map<String, dynamic>>[];

      vehiclesSnapshot.children.forEach((vehicleSnapshot) {
        final vehicleData = vehicleSnapshot.value as Map<dynamic, dynamic>;
        vehiclesList.add({
          'id': vehicleSnapshot.key,
          'name': vehicleData['name'],
          'model': vehicleData['model'],
          'year': vehicleData['year'],
          'plate': vehicleData['plate'],
        });
      });

      setState(() {
        vehicles = vehiclesList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar veículos!")),
      );
    }
  }

  Future<void> _getRefuels() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuário não autenticado")),
        );
      });
      return;
    }

    if (selectedVehicleId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selecione um veículo")),
        );
      });
      return;
    }

    try {
      final refuelsSnapshot = await _database
          .child('vehicles/$userId/$selectedVehicleId/refuels')
          .get();

      if (!refuelsSnapshot.exists) {
        setState(() {
          refuels = [];
          averageConsumption = null;
        });
        return;
      }

      final refuelsList = <Map<String, dynamic>>[];

      refuelsSnapshot.children.forEach((refuelSnapshot) {
        final refuelData = refuelSnapshot.value as Map<dynamic, dynamic>;
        refuelsList.add({
          'id': refuelSnapshot.key,
          'liters': refuelData['liters'],
          'currentMileage': refuelData['currentMileage'],
          'date': DateTime.fromMillisecondsSinceEpoch(refuelData['date']),
        });
      });

      setState(() {
        refuels = refuelsList;
        _calculateAverageConsumption();
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar abastecimentos!")),
        );
      });
    }
  }

  void _calculateAverageConsumption() {
    if (refuels.length < 2) {
      setState(() {
        averageConsumption = null; 
      });
      return;
    }

    refuels.sort((a, b) => a['date'].compareTo(b['date']));

    double totalLiters = 0;
    double totalMileageDifference = 0;

    for (int i = 1; i < refuels.length; i++) {
      final mileageDifference =
          refuels[i]['currentMileage'] - refuels[i - 1]['currentMileage'];
      final liters = refuels[i]['liters'];

      if (mileageDifference > 0 && liters > 0) {
        totalLiters += liters;
        totalMileageDifference += mileageDifference;
      }
    }

    if (totalLiters > 0) {
      setState(() {
        averageConsumption =
            totalMileageDifference / totalLiters; 
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Abastecimento',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedVehicleId,
              hint: Text('Selecione o Veículo'),
              onChanged: (value) {
                setState(() {
                  selectedVehicleId = value;
                });
                _getRefuels();
              },
              items: vehicles.map((vehicle) {
                return DropdownMenuItem<String>(
                  value: vehicle['id'],
                  child: Text(vehicle['name']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Veículo',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.directions_car, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            if (averageConsumption != null)
              Text(
                'Média de consumo: ${averageConsumption!.toStringAsFixed(2)} km/L',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: refuels.length,
                itemBuilder: (context, index) {
                  final refuel = refuels[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading:
                          Icon(Icons.local_gas_station, color: Colors.green),
                      title: Text('Litros: ${refuel['liters']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quilometragem: ${refuel['currentMileage']}'),
                          Text('Data: ${_formatDate(refuel['date'])}'),
                        ],
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_refuel');
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
