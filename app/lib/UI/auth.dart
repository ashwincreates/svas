import 'package:flutter/material.dart';
import 'package:app/model/auth.dart' as token;
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "svas",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Login(),
    );
  }
}

class Login extends StatelessWidget {
  Login({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Login", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 32),
          TextField(
            controller: email,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: password,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(hintText: "Password"),
          ),
          const Expanded(child: SizedBox()),
          TextButton(
            onPressed: () {
              Provider.of<token.Auth>(context, listen: false)
                  .login(email.text, password.text);
            },
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.blue),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
              fixedSize: MaterialStatePropertyAll(
                  Size.fromWidth(MediaQuery.of(context).size.width)),
            ),
            child: const Text("Login"),
          ),
        ]));
  }
}

