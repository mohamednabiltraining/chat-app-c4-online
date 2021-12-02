import 'package:chat_app_c4_online/hom_screen.dart';
import 'package:chat_app_c4_online/add_room.dart';
import 'package:chat_app_c4_online/providers/auth_provider.dart';
import 'package:chat_app_c4_online/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider<AuthProvider>(
      create: (buildContext) => AuthProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
              color: Colors.transparent, centerTitle: true, elevation: 0)),
      routes: {
        RegisterScreen.routeName: (buildContext) => RegisterScreen(),
        LoginScreen.routeName: (buildContext) => LoginScreen(),
        HomeScreen.routeName: (buildContext) => HomeScreen(),
        AddRoomScreen.routeName: (buildContext) => AddRoomScreen(),
      },
      initialRoute:
          provider.isLoggedIn() ? HomeScreen.routeName : LoginScreen.routeName,
    );
  }
}
