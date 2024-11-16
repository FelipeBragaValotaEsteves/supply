import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';

const kPrimaryColor = Colors.green;
const kButtonTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
const kLabelStyle = TextStyle(color: Colors.green);
const kInputDecoration = InputDecoration(
  labelStyle: kLabelStyle,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  prefixIcon: Icon(Icons.email, color: kPrimaryColor),
);

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao fazer login!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: kInputDecoration.copyWith(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: kInputDecoration.copyWith(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock, color: kPrimaryColor)),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:() => _login(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text("ENTRAR", style: kButtonTextStyle),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                "Não tem uma conta? Cadastre-se",
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
