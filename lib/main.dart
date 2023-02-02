import 'package:flutter/material.dart';
import 'package:messages_reader/home_screen.dart';
import 'package:messages_reader/phone_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
String phone;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs =await SharedPreferences.getInstance();
  phone = prefs.getString('phone');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: phone == null?PhoneScreen(): HomeScreen(phone: phone,),
    );
  }
}