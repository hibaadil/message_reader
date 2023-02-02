import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:messages_reader/phone_screen.dart';
import 'package:sms/sms.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.phone});
  final String phone;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SmsQuery query = SmsQuery();
  Completer<GoogleMapController> _controller = Completer();
  String message;
  double lat;
  double long;
  bool isLocation;
  CameraPosition cameraPosition;
  bool isLoading = true;
  bool wrongNumber = false;
  List<SmsMessage> messages = [];
  Future<bool> fetchMessage() async {
    messages = await query
        .querySms(address: widget.phone);
    message =messages.isEmpty?'هذا الرقم غير موجود حاول مرة اخرى' :  messages.first.body;

    if (message.contains(',')) {
      lat = double.parse(message.split(',')[0]);
      long = double.parse(message.split(',')[1]);
      setState(() {
        isLocation = true;
      });
      return true;
    } else {
      setState(() {
        isLocation = false;
      });
      return false;
    }
  }

  initPage() async {
    bool initMap = await fetchMessage();
    setState(() {
      isLocation = initMap;
      isLoading = false;
    });
  }

  @override
  void initState() {
    initPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : wrongNumber
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('هذا الرقم غير موجود حاول مرة اخرى'),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => PhoneScreen()));
                          },
                          child: Text('رجوع'))
                    ],
                  ))
                : isLocation
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          GoogleMap(
                            myLocationEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            initialCameraPosition: CameraPosition(
                                target: LatLng(lat, long), zoom: 100.0),
                            mapType: MapType.hybrid,
                            markers: {
                              Marker(markerId: MarkerId('the point'),position: LatLng(lat, long) )
  },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                await fetchMessage();
                                final GoogleMapController controller =
                                    await _controller.future;
                                controller.moveCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                  target: LatLng(lat, long),
                                  zoom: 50,
                                )));
                                // SharedPreferences prefrances =await SharedPreferences.getInstance();
                                // prefrances.remove('phone');
                                // prefrances.clear();

                                setState(() {});
                              },
                              child: Text('تحديث'),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: messages.isEmpty? (){
                                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>PhoneScreen()));
                                  }:() async {
                                    fetchMessage();
                                    final GoogleMapController controller =
                                        await _controller.future;
                                    controller.moveCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                      target: LatLng(lat, long),
                                      zoom: 100.0,
                                    )));
                                    },
                                  child: Text(messages.isEmpty ? 'رجوع'  :'تحديث'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
  }
}
