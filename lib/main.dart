import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imagin_true/Earth.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/sharedHELper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Chat/Cubit/cubit.dart';
import 'Chat/Cubit/states.dart';
import 'constant.dart';
import 'login/login_screen.dart';

Future<PermissionStatus> getContactPermission() async {
  PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.permanentlyDenied) {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    return permissionStatus;
  } else {
    return permission;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PermissionStatus permissionStatus = await getContactPermission();
  await Shard.initial();
  String? s;
  uId = Shard.sharedprefrences!.getString('uId');
  print(uId);
  Widget widget;
  if (uId != null && permissionStatus == PermissionStatus.granted) {
    widget = const Earth();
  } else {
    widget = LoginScreen();
  }
  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  Widget widget;

  MyApp(this.widget);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(this.widget),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget widget;

  MyHomePage(this.widget);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var x = 5;

  @override
  Widget build(BuildContext context) {
    var scaff = ScaffoldMessenger.of(context);
    FirebaseMessaging.onMessage.listen((event) {
      print(event.data.toString());
      scaff.showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55),
                  color: Colors.green,
                ),
                child: const Center(
                  child: Text("You received a message"),
                ),
              ),
            ],
          ),
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.data.toString());
      scaff.showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55),
                  color: Colors.green,
                ),
                child: const Center(
                  child: Text("You received a message"),
                ),
              ),
            ],
          ),
        ),
      );
    });

    return BlocProvider(
      create: (BuildContext context) => ChatCubit()..getUsers(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            body: widget,
          );
        },
      ),
    );
  }
}
