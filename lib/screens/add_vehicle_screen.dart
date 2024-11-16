import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  Future<void> _addVehicle() async {
    final vehicleData = {
      'name': nameController.text,
      'model': modelController.text,
      'year': int.parse(yearController.text),
      'plate': plateController.text,
    };

    await FirebaseFirestore.instance.collection('vehicles').add(vehicleData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nome do Veículo')),
            TextField(controller: modelController, decoration: InputDecoration(labelText: 'Modelo')),
            TextField(controller: yearController, decoration: InputDecoration(labelText: 'Ano')),
            TextField(controller: plateController, decoration: InputDecoration(labelText: 'Placa')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addVehicle, child: Text('Adicionar'))
          ],
        ),
      ),
    );
  }
}
