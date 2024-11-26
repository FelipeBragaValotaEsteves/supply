import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRefuelScreen extends StatefulWidget {
  @override
  _AddRefuelScreenState createState() => _AddRefuelScreenState();
}

class _AddRefuelScreenState extends State<AddRefuelScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TextEditingController litersController = TextEditingController();
  final TextEditingController currentMileageController =
      TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectedVehicleId;
  List<Map<String, dynamic>> vehicles = [];
  DateTime? selectedDate;

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

  Future<void> _addRefuel() async {
    final liters = double.tryParse(litersController.text);
    final currentMileage = int.tryParse(currentMileageController.text);

    if (selectedVehicleId == null ||
        liters == null ||
        currentMileage == null ||
        selectedDate == null) {
      _showMessageDialog(
          "Erro", "Por favor, preencha todos os campos corretamente!");
      return;
    }

    final refuelData = {
      'liters': liters,
      'currentMileage': currentMileage,
      'date': selectedDate?.millisecondsSinceEpoch,
    };

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final refuelRef =
          _database.child('vehicles/$userId/$selectedVehicleId/refuels').push();

      await refuelRef.set(refuelData);

      _showMessageDialog("Sucesso", "Abastecimento adicionado com sucesso!");
    } catch (e) {
      _showMessageDialog(
          "Erro", "Falha ao adicionar o abastecimento. Tente novamente.");
    }
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Abastecimento',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
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
              },
              items: vehicles.isEmpty
                  ? [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text("Cadastre um veículo"),
                      ),
                    ]
                  : vehicles.map((vehicle) {
                      return DropdownMenuItem<String>(
                        value: vehicle['id'],
                        child: Text("${vehicle['name']} - ${vehicle['plate']}"),
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
            TextField(
              controller: litersController,
              decoration: InputDecoration(
                labelText: 'Litros',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.local_gas_station, color: Colors.green),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            TextField(
              controller: currentMileageController,
              decoration: InputDecoration(
                labelText: 'Quilometragem Atual',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.speed, color: Colors.green),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addRefuel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "ADICIONAR ABASTECIMENTO",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
