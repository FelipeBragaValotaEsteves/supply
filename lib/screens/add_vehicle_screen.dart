import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/custom_drawer.dart'; 

class AddVehicleScreen extends StatefulWidget {
  final String? vehicleId; 

  AddVehicleScreen({this.vehicleId}); 

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref("vehicles");

  @override
  void initState() {
    super.initState();
    if (widget.vehicleId != null) {
      _loadVehicleData(widget.vehicleId!);
    }
  }

  Future<void> _loadVehicleData(String vehicleId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _database.child(user.uid).child(vehicleId).get();
    if (snapshot.exists) {
      final vehicleData = snapshot.value as Map;
      nameController.text = vehicleData['name'] ?? '';
      modelController.text = vehicleData['model'] ?? '';
      yearController.text = vehicleData['year']?.toString() ?? '';
      plateController.text = vehicleData['plate'] ?? '';
    }
  }

  Future<void> _saveVehicle() async {
    if (nameController.text.isEmpty ||
        modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        plateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, preencha todos os campos!")),
      );
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuário não autenticado!")),
      );
      return;
    }

    final vehicleData = {
      'name': nameController.text,
      'model': modelController.text,
      'year': int.parse(yearController.text),
      'plate': plateController.text,
    };

    if (widget.vehicleId != null) {
      await _database.child(user.uid).child(widget.vehicleId!).update(vehicleData);
    } else {
      await _database.child(user.uid).push().set(vehicleData);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicleId != null ? 'Editar Veículo' : 'Adicionar Veículo',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Veículo',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.drive_eta, color: Colors.green),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: modelController,
              decoration: InputDecoration(
                labelText: 'Modelo',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.drive_eta, color: Colors.green),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: yearController,
              decoration: InputDecoration(
                labelText: 'Ano',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: plateController,
              decoration: InputDecoration(
                labelText: 'Placa',
                labelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.drive_eta, color: Colors.green),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveVehicle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.vehicleId != null ? "SALVAR" : "ADICIONAR",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
