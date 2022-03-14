//import 'package:contacts_service_example/contacts_list_page.dart';
//import 'package:contacts_service_example/contacts_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/sharedHELper.dart';
import 'Chat/Cubit/cubit.dart';
import 'Chat/Cubit/states.dart';
import 'Chat/chat.dart';
import 'constant.dart';
import 'login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print('the token is :' + token.toString());
  String? define;
  final DeviceInfoPlugin dev = new DeviceInfoPlugin();
  if(Platform.isAndroid){
    var build = await dev.androidInfo;
    define= build.id.toString();
    print(build.fingerprint);
    print("the define is "+define.toString());
  }
  await Shard.initial();
  Shard.saveData(key: "sss", value: "Ahmad");
  String? s;
  uId = Shard.sharedprefrences!.getString('uId');
  print(uId);
  Widget widget;
  if (uId != null) {
    widget = const Chat();
  } else {
    widget = LoginScreen();
  }
  runApp(ContactsExampleApp());
  //runApp(MyApp(widget));
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

  void getNotification() async {}

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
    /*FirebaseMessaging.onBackgroundMessage((message) async {
      print('onBackGroundMessageOpenedApp');
      print(message.data.toString());
      scaff.showSnackBar(
        SnackBar(
          content: const Text("onBackGroundMessageOpenedApp"),
          action: SnackBarAction(
              label: "onBackGroundMessageOpenedApp", onPressed: () {}),
        ),
      );
    });*/
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

/*Center(
              child: MaterialButton(
                onPressed: (){
                  FCM();
                },
                child: Text('HEy'),
              ),
            ),
 */
  Future<bool> FCM(String userToken) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to":userToken.toString(),
      "collapse_key": "type_a",
      "notification": {
        "title": "You Get a message",
        "body": "Ahmad Al_Frehan",
        "sound": "default"
      },
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": "true",
          "default_vibrate_timings": "true",
          "default_light_settings": "true"
        }
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA8m3TVe4:APA91bG-hd_s5UmupukipOSJbfsbhrsDzpgNrfdS_G23uO-BSmHFFjPvW5lIvgb2IjtJjBCxDSNd0t41NLNhKpvSE7ts27E4edFKVoL77f_vMpVhBk3LN3F0KZcji4xs67OAdHec0sWS '
    };
    try {
      final response = await http.post(
        Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      );
      //post(postUrl, data: data);
      if (response.statusCode == 200) {
        print('done');
        print(response.statusCode);
        return true;
      } else {
        print('error');
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e.toString());
    }
    return true;
  }
}

// iOS only: Localized labels language setting is equal to CFBundleDevelopmentRegion value (Info.plist) of the iOS project
// Set iOSLocalizedLabels=false if you always want english labels whatever is the CFBundleDevelopmentRegion value.
const iOSLocalizedLabels = false;

class ContactsExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        //'/add': (BuildContext context) => AddContactPage(),
        //'/contactsList': (BuildContext context) => ContactListPage(),
        //'/nativeContactPicker': (BuildContext context) => ContactPickerPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _askPermissions('/add');
  }

  Future<void> _askPermissions(String routeName) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      if (routeName != null) {
        Navigator.of(context).pushNamed(routeName);
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Plugin Example')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Contacts list'),
              onPressed: () => _askPermissions('/contactsList'),
            ),
            ElevatedButton(
              child: const Text('Native Contacts picker'),
              onPressed: () => _askPermissions('/nativeContactPicker'),
            ),
          ],
        ),
      ),
    );
  }
}