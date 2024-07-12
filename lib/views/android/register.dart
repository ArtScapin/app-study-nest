import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../globals.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void goToLogin() {
      Navigator.pop(context);
    }

    Future<void> register() async {
      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        return;
      }

      try {
        final response = await http.post(
        Uri.parse('$apiUrl/user'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
          );

        if (response.statusCode == 200) {
          goToLogin();
        } else {
          debugPrint('error response');
        }
      } catch (e) {
        debugPrint('error api');
      }
    }

    return MaterialApp(
      title: 'Login Screen',
      home: Scaffold(
        backgroundColor: const Color(0xFF101511),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/logo.png', height: 150),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Color(0xFF181D19),
                      labelStyle: TextStyle(color: Color(0xFF04F781)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1B6040)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF04F781)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: const Color(0xFF1B6040),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Color(0xFF181D19),
                      labelStyle: TextStyle(color: Color(0xFF04F781)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1B6040)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF04F781)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: const Color(0xFF1B6040),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Color(0xFF181D19),
                      labelStyle: TextStyle(color: Color(0xFF04F781)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1B6040)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF04F781)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    obscureText: true,
                    cursorColor: const Color(0xFF1B6040),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6040),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: "Login",
                            style: const TextStyle(
                              color: Color(0xFF04F781),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = goToLogin,
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
