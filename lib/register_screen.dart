import 'package:chat_app_c4_online/data/firestore_utils.dart';
import 'package:chat_app_c4_online/hom_screen.dart';
import 'package:chat_app_c4_online/providers/auth_provider.dart';
import 'package:chat_app_c4_online/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_c4_online/data/user.dart' as AppUser;
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firstName = '',
      lastName = '',
      userName = '',
      email = '',
      password = '';

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
          appBar: AppBar(title: Text('Create Account')),
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
                      decoration: InputDecoration(labelText: 'First Name'),
                      onChanged: (text) {
                        firstName = text;
                      },
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter first Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Last Name'),
                        onChanged: (text) {
                          lastName = text;
                        },
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter last Name';
                          }
                          return null;
                        }),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'User Name'),
                        onChanged: (text) {
                          userName = text;
                        },
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter user Name';
                          }
                          return null;
                        }),
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
                            createAccountWithFirebaseAuth();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Creat Account'),
                              Icon(Icons.arrow_right)
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccountWithFirebaseAuth() async {
    try {
      showLoading(context);

      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // to register user in our database

      hideLoading(context);
      if (result.user != null) {
        var myUser = AppUser.User(
            id: result.user!.uid,
            userName: userName,
            firstName: firstName,
            lastName: lastName,
            email: email);
        addUserToFireStore(myUser).then((value) {
          provider.updateUser(myUser);
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }).onError((error, stackTrace) {
          showMessage(error.toString(), context);
        });
      }
    } catch (error) {
      hideLoading(context);
      showMessage(error.toString(), context);
    }
  }
}
