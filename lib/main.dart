import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:imagin_true/Earth.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/sharedHELper.dart';
import 'Chat/Cubit/cubit.dart';
import 'Chat/Cubit/states.dart';
import 'constant.dart';
import 'login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print('the token is :' + token.toString());
  String? define;
  final DeviceInfoPlugin dev = new DeviceInfoPlugin();
  if (Platform.isAndroid) {
    var build = await dev.androidInfo;
    define = build.id.toString();
    print(build.fingerprint);
    print("the define is " + define.toString());
  }
  var list = ContactsService.getContacts();
  print(list.toString());
  await Shard.initial();
  Shard.saveData(key: "sss", value: "Ahmad");
  String? s;
  uId = Shard.sharedprefrences!.getString('uId');
  print(uId);
  Widget widget;
  if (uId != null) {
    widget = const Earth();
  } else {
    widget = LoginScreen();
  }
  //runApp(ContactsExampleApp());
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var scaff = ScaffoldMessenger.of(context);
    FirebaseMessaging.onMessage.listen((event) {
      print('onMessaging');
      print(event.data.toString());
      scaff.showSnackBar(
        SnackBar(
          content: const Text("onMessaging"),
          action: SnackBarAction(label: "onMessage", onPressed: () {}),
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('onMessageOpenedApp');
      print(event.data.toString());
      scaff.showSnackBar(SnackBar(
        content: const Text("onMessageOpenedApp"),
        action: SnackBarAction(label: "onMessageOpenedApp", onPressed: () {}),
      ));
    });
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getContacts(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(key: _scaffoldKey, body: widget);
        },
      ),
    );
  }
}
