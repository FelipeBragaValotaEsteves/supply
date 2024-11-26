import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/vehicle_list_screen.dart';
import 'screens/add_vehicle_screen.dart';
import 'screens/refuel_history_screen.dart';
import 'screens/add_refuel_screen.dart'; 
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AbastecimentoApp());
}

class AbastecimentoApp extends StatelessWidget {
  const AbastecimentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Abastecimento',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/vehicles': (context) => VehicleListScreen(),
        '/add_vehicle': (context) => AddVehicleScreen(),
        '/refuels': (context) => RefuelHistoryScreen(),
        '/add_refuel': (context) => AddRefuelScreen(), 
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
