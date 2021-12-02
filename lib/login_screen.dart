import 'package:chat_app_c4_online/data/firestore_utils.dart';
import 'package:chat_app_c4_online/hom_screen.dart';
import 'package:chat_app_c4_online/providers/auth_provider.dart';
import 'package:chat_app_c4_online/register_screen.dart';
import 'package:chat_app_c4_online/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';

  var formKey = GlobalKey<FormState>();
  late AuthProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context);
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/pattern.png'))),
        child: Scaffold(
          appBar: AppBar(title: Text('Sing In')),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onChanged: (text) {
                          email = text;
                        },
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter email';
                          }
                          if (!isValidEmail(email)) {
                            return 'please enter a valid email';
                          }
                          return null;
                        }),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'password'),
                      onChanged: (text) {
                        password = text;
                      },
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter password';
                        }
                        if (text.length < 6) {
                          return 'password should be at least 6 chars';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            lginWithFirebaseAuth();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sign In'),
                              Icon(Icons.arrow_right)
                            ],
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RegisterScreen.routeName);
                        },
                        child: Text('Or Create Account!'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void lginWithFirebaseAuth() async {
    try {
      showLoading(context);

      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      hideLoading(context);
      if (result.user != null) {
        //showMessage('user Logged in successfully', context);
        // retrieve user from DB
        var firestoreUser = await getUserById(result.user!.uid);
        if (firestoreUser != null) {
          // save user in provider
          provider.updateUser(firestoreUser);
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      }
    } catch (error) {
      hideLoading(context);
      showMessage('invalid email or password', context);
    }
  }
}
