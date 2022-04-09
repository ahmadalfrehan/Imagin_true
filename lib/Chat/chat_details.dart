import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/Chat/HisProfile.dart';
import '../constant.dart';
import '../modulo/chatModel.dart';
import '../modulo/usersmoder.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';

class ChatDetailes extends StatelessWidget {
  UsersModel users;

  ChatDetailes(this.users);

  var chatTextControoler = TextEditingController();
  final ScrollController controllerScrol = ScrollController();

  void scrollSown() {
    controllerScrol.jumpTo(controllerScrol.position.maxScrollExtent);
  }

  bool isAutoScrolling = true;
  String s = 'ahmad';
  bool isarabic = false;
  int Cp = 0xFFECF0F3;

  Future<bool> FCM(String userToken, String name) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": userToken.toString(),
      "collapse_key": "type_a",
      "notification": {
        "title": name.toString(),
        "body": chatTextControoler.text,
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
          'key='
    };
    try {
      final response = await http.post(
        Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers,
      );
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

  String wallPaperC = 'Color(0xFFECF0F3)';

  @override
  Widget build(BuildContext context) {
    var scaff = ScaffoldMessenger.of(context);
    Size S = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getMessages(
          reciverID: users.uId.toString(),
        ),
      child: Builder(
        builder: (BuildContext context) {
          print(S.height);
          print(S.width);
          //if(WallPaperColor!=null) wallPaperC = WallPaperColor!.substring(35);
          //wallPaperC = wallPaperC.substring(6,16);
          //Cp = int.parse(wallPaperC);
          //print(Cp);
          //print(wallPaperC);
          if (ChatCubit.get(context).UU == null) {
            ChatCubit.get(context).getUsers();
          } else {
            ChatCubit.get(context).getMessages(
              reciverID: users.uId.toString(),
            );
          }
          return BlocConsumer<ChatCubit, SocialStates>(
            listener: (context, state) {
              if (state is SocialUploadFileLoadingStates) {
                const Center(
                  child: LinearProgressIndicator(),
                );
              }
              if (state is SocialUploadFileSuccessStates) {
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
                            child: Text("The File Sent Successfully"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is SocialUploadFileErrorStates) {
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
                            color: Colors.red,
                          ),
                          child: const Center(
                            child: Text("An error occurred try again !"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is SocialDownLoadFileLoadingStates) {
                const Center(
                  child: LinearProgressIndicator(),
                );
              }
              if (state is SocialDownLoadFileSavedStates) {
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
                            child: Text("The File Saved Successfully"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is SocialDownLoadFileSavedErrorStates) {
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
                            color: Colors.red,
                          ),
                          child: const Center(
                            child: Text("Error When saved the file try again "),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              ChatCubit.get(context).getMessages(
                reciverID: users.uId.toString(),
              );
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  elevation: 0,
                  titleSpacing: 0,
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HisProfile(users),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            users.profilePicturePrivacy != 'No Body'
                                ? users.ImageProfile.toString()
                                : defaultProrfilePictures,
                          ),
                        ),
                        SizedBox(
                          width: S.width * 0.01,
                        ),
                        Text(users.name.toString()),
                      ],
                    ),
                  ),
                  toolbarHeight:
                      S.width >= 700 ? S.height * 0.13 : S.height * 0.08,
                ),
                body: Container(
                  color: isDark ? Color(0) : Color(0xFFECF0F3),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                //controller: ChatCubit.get(context).scroll,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    ChatCubit.get(context).messages.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemBuilder: (context, index) {
                                  var t =
                                      ChatCubit.get(context).messages[index];
                                  if (ChatCubit.get(context).UU!.uId ==
                                      t.SenderID) {
                                    return MyMessage(t, context);
                                  }
                                  return HisMessage(t, context);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.blueGrey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ChatCubit.get(context).getFiles();
                                    },
                                    child: const Icon(
                                      Icons.attachment,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        cursorColor: Colors.black,
                                        textDirection:
                                            ChatCubit.get(context).isarabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        onChanged: (value) {
                                          ChatCubit.get(context).isArabic(
                                              chatTextControoler.text);
                                        },
                                        toolbarOptions: const ToolbarOptions(
                                          copy: true,
                                          cut: true,
                                          selectAll: true,
                                          paste: true,
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        maxLines: S.width >= 450 ? 2 : 6,
                                        minLines: 1,
                                        decoration: const InputDecoration(
                                          hintText:
                                              " type your message here ..",
                                          border: InputBorder.none,
                                        ),
                                        controller: chatTextControoler,
                                        keyboardType: TextInputType.multiline,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'the message must not be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  if (chatTextControoler.text != '' ||
                                      ChatCubit.get(context).file != null)
                                    MaterialButton(
                                      minWidth: S.width * 0.01,
                                      onPressed: () {
                                        if (ChatCubit.get(context).file ==
                                            null) {
                                          ChatCubit.get(context).SendMessaege(
                                            reciverID: users.uId as String,
                                            text: chatTextControoler.text,
                                            dateTime: DateTime.now().toString(),
                                            isRead: false,
                                          );
                                          FCM(
                                            users.Token.toString(),
                                            ChatCubit.get(context)
                                                .UU!
                                                .name
                                                .toString(),
                                          );
                                          chatTextControoler =
                                              TextEditingController();
                                        } else {
                                          ChatCubit.get(context).uploadFile(
                                            reciverID: users.uId as String,
                                            text: chatTextControoler.text,
                                            dateTime: DateTime.now().toString(),
                                            isRead: false,
                                          );
                                          FCM(
                                            users.Token.toString(),
                                            ChatCubit.get(context)
                                                .UU!
                                                .name
                                                .toString(),
                                          );
                                          chatTextControoler =
                                              TextEditingController();
                                          ChatCubit.get(context).file = null;
                                        }
                                      },
                                      child: const Icon(Icons.send_rounded),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: S.width * 0.01,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget MyMessage(ChatModel t, context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: t.Url == ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      '${t.text}',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontSize: fontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${t.dateTime!.substring(10, 16)}',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                    Icon(t.isRead == true ? Icons.check_box_sharp : Icons.check,
                        size: 10),
                  ],
                )
              : InkWell(
                  onTap: () {
                    var e = AlertDialog(
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              'cancel',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text("Save File ? "),
                        content: ElevatedButton(
                          onPressed: () {
                            ChatCubit.get(context)
                                .SaveFile(Url: t.Url.toString());
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.download),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Save ?'),
                            ],
                          ),
                        ));
                    showDialog(context: context, builder: (context) => e);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            image: t.Url!.split('.').last.substring(0, 3) ==
                                        'jpg' ||
                                    t.Url!.split('.').last.substring(0, 3) ==
                                        'png'
                                ? DecorationImage(
                                    image: NetworkImage(
                                      t.Url.toString(),
                                    ),
                                    fit: BoxFit.contain,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                        'https://img.freepik.com/free-psd/3d-rendering-ui-icon_23-2149182288.jpg?size=338&ext=jpg&ga=GA1.2.44267276.1645656478'))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectableText(
                        '${t.text}',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${t.dateTime!.substring(10, 16)}' + '   \u2713',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );

  Widget HisMessage(ChatModel t, context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: t.Url == ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      '${t.text}',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontSize: fontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${t.dateTime!.substring(10, 16)}',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () {
                    var e = AlertDialog(
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'cancel',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text("Save File ? "),
                      content: ElevatedButton(
                        onPressed: () {
                          ChatCubit.get(context)
                              .SaveFile(Url: t.Url.toString());
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.download),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Save ?'),
                          ],
                        ),
                      ),
                    );
                    showDialog(context: context, builder: (context) => e);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            image: t.Url!.split('.').last.substring(0, 3) ==
                                        'jpg' ||
                                    t.Url!.split('.').last.substring(0, 3) ==
                                        'png'
                                ? DecorationImage(
                                    image: NetworkImage(
                                      t.Url.toString(),
                                    ),
                                    fit: BoxFit.contain,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                        'https://img.freepik.com/free-psd/3d-rendering-ui-icon_23-2149182288.jpg?size=338&ext=jpg&ga=GA1.2.44267276.1645656478'))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectableText(
                        t.text.toString(),
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${t.dateTime!.substring(10, 16)}',
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}
