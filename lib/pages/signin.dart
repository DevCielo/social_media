import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_tree/pages/signup.dart';
import 'package:widget_tree/providers/user_provider.dart';

class SignIn extends ConsumerStatefulWidget {
  SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends ConsumerState<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(r"^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signInKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(FontAwesomeIcons.twitter, color:  Colors.blue, size: 70,),
              SizedBox(height: 20),
              const Text('Log in to Mixtape', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter an Email',
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20,),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!emailValid.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                  },
               ), 
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter a Password',
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20,),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be atleast 6 character';
                  }
                },
                ),
              ),
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                  onPressed: () async {
                    if(_signInKey.currentState!.validate()) {
                      try { 
                        await _auth.signInWithEmailAndPassword(
                        email: _emailController.text,
                         password: _passwordController.text,
                        );
                        ref.read(userProvider.notifier).login(_emailController.text);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                      }
                    }
                  },
                  child: const Text('Log in', style: TextStyle(color: Colors.white, fontSize: 18 )),
              ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text("Don't have an account? Sign up here")
              )
            ],
          ),
        ),
      );
  }
}