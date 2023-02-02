import 'package:flutter/material.dart';
import 'package:messages_reader/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                TextFormField(
                  textAlign: TextAlign.end,
                  controller: phoneController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'مطلوب';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'أدخل الرقم المٌرسِل للرسالة',
                      labelStyle: TextStyle(fontSize: 20)),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        showDialog(context: context, builder: (builder)=>AlertDialog(
                          actions: [
                            ElevatedButton(onPressed: ()async{
                              SharedPreferences prefs =await SharedPreferences.getInstance();
                              prefs.setString('phone', phoneController.text);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          HomeScreen(phone: phoneController.text)),
                                      (route) => false);

                            }, child: Text('نعم')),

                            ElevatedButton(onPressed: (){
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          HomeScreen(phone: phoneController.text)),
                                      (route) => false);

                            }, child: Text('لا')),
                          ],
                          content: Text('هل تريد الإستقبال دائما من هذا الرقم؟'),));

                      }
                    },
                    child: Text('تم'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
