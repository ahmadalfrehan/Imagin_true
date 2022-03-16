import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  String s = 'ahmad';
  bool isarabic = false;

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

  @override
  Widget build(BuildContext context) {
    Size S = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getMessages(
          reciverID: users.uId.toString(),
        ),
      child: Builder(
        builder: (BuildContext context) {
          if (ChatCubit.get(context).UU == null) {
            ChatCubit.get(context).getUsers();
          } else {
            ChatCubit.get(context).getMessages(
              reciverID: users.uId.toString(),
            );
          }
          return BlocConsumer<ChatCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              ChatCubit.get(context).getMessages(
                reciverID: users.uId.toString(),
              );
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.teal,
                  elevation: 0,
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          users.ImageProfile.toString(),
                        ),
                      ),
                      SizedBox(
                        width: S.width * 0.01,
                      ),
                      Text(users.name.toString()),
                    ],
                  ),
                  toolbarHeight: S.height * 0.08,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: ChatCubit.get(context).messages.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemBuilder: (context, index) {
                            var t = ChatCubit.get(context).messages[index];
                            if (ChatCubit.get(context).UU!.uId == t.SenderID) {
                              return MyMessage(t);
                            }
                            return HisMessage(t);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            //if (chatTextControoler.text == '')
                            InkWell(
                              onTap: () {
                                ChatCubit.get(context).getFiles();
                              },
                              //height: 1,
                              //minWidth: 0,
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
                                  textDirection: ChatCubit.get(context).isarabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  onChanged: (value) {
                                    ChatCubit.get(context).isArabic(chatTextControoler.text);
                                  },
                                  toolbarOptions: const ToolbarOptions(
                                    copy: true,
                                    cut: true,
                                    selectAll: true,
                                    paste: true,
                                  ),
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: 12,
                                  minLines: 1,
                                  decoration: const InputDecoration(
                                    hintText: " type your message here ..",
                                    border: InputBorder.none,
                                  ),
                                  controller: chatTextControoler,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'the message must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            if (chatTextControoler.text != '')
                              MaterialButton(
                                minWidth: S.width * 0.01,
                                onPressed: () {
                                  ChatCubit.get(context).SendMessaege(
                                    reciverID: users.uId as String,
                                    text: chatTextControoler.text,
                                    dateTime: DateTime.now().toString(),
                                  );
                                  FCM(
                                    users.Token.toString(),
                                    ChatCubit.get(context).UU!.name.toString(),
                                  );
                                  chatTextControoler = TextEditingController();
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
              );
            },
          );
        },
      ),
    );
  }

  Widget MyMessage(ChatModel t) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: Text(
            '${t.text}',
            style: const TextStyle(
              fontFamily: 'Raleway',
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget HisMessage(ChatModel t) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Text(
            t.text.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
}
