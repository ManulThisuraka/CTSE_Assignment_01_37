import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/app_theme.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(userCredential.user)),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(userCredential.user)),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBar,
        title:
            const Text(style: TextStyle(color: AppTheme.background), "Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppTheme.appBar, width: 3.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: HexColor('#B9BABC'),
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.2,
                                      color: HexColor('#B9BABC'),
                                    ),
                                  ),
                                  onEditingComplete: () {},
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child:
                                  Icon(Icons.email, color: HexColor('#B9BABC')),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppTheme.appBar, width: 3.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: HexColor('#B9BABC'),
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.2,
                                      color: HexColor('#B9BABC'),
                                    ),
                                  ),
                                  onEditingComplete: () {},
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Icon(Icons.password,
                                  color: HexColor('#B9BABC')),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blueButton,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    elevation: 5,
                  ),
                  onPressed: _login,
                  child: const Text(
                      style: TextStyle(color: AppTheme.background), 'Login')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Already haven't an account? ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextButton(
                      onPressed: _register,
                      child: const Text(
                          style:
                              TextStyle(color: Color.fromRGBO(38, 51, 197, 1)),
                          'Sign Up'))
                ],
              ),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
