import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/presentation/sharedHELper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/Config/Config.dart';
import 'presentation/Chat/Cubit/cubit.dart';
import 'presentation/Chat/Cubit/states.dart';
import 'presentation/Home/HomeScreen.dart';
import 'presentation/login/login_screen.dart';

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
  WallPaperColor = Shard.sharedprefrences!.getString('ColorWall');
  if (Shard.sharedprefrences!.getBool('darkMode') != null)
    isDark = Shard.sharedprefrences!.getBool('darkMode')!;
  fontSize = Shard.sharedprefrences!.getDouble('FontSized');
  print(fontSize);
  uId = Shard.sharedprefrences!.getString('uId');
  print(uId);
  print(PermissionStatus.granted);
  print(permissionStatus);
  print(permissionStatus);
  if (permissionStatus != PermissionStatus.granted) {
    uId = null;
    print('object');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: isDark
          ? ThemeData(
              primarySwatch: Colors.orange,
              brightness: Brightness.dark,
            )
          : ThemeData(
              primarySwatch: Colors.orange,
              brightness: Brightness.light,
            ),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: uId != null ? Home() : LoginScreen(),
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
