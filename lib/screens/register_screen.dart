import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const kPrimaryColor = Colors.green;
const kTextColor = Colors.black;
const kButtonTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
const kLabelStyle = TextStyle(color: Colors.green);
const kInputDecoration = InputDecoration(
  labelStyle: kLabelStyle,
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  prefixIcon: Icon(Icons.email, color: kPrimaryColor),
);

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cadastro realizado com sucesso!")),
        );
        Navigator.pop(context); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao cadastrar: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Usuário", style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: kInputDecoration.copyWith(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira um e-mail";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: kInputDecoration.copyWith(labelText: "Senha", prefixIcon: Icon(Icons.lock, color: kPrimaryColor)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "A senha deve ter pelo menos 6 caracteres";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("CADASTRAR", style: kButtonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
