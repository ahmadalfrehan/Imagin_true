import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/Config/Config.dart';
import '../../main.dart';
import '../Chat/Cubit/cubit.dart';
import '../Chat/Cubit/states.dart';
import '../login/login_screen.dart';
import '../sharedHELper.dart';

class SettingsS extends StatelessWidget {
  SettingsS({Key? key}) : super(key: key);
  List<Color> colors = [
    Colors.yellowAccent,
    Colors.purpleAccent,
    Colors.limeAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
    Colors.deepPurple,
    Colors.deepOrangeAccent,
    Colors.amberAccent,
    Colors.orangeAccent,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.amber,
    Colors.cyan,
    Colors.red,
    Colors.pink,
    Colors.green,
    Colors.blue,
    Colors.blueGrey,
    Colors.grey,
    Colors.greenAccent,
    Colors.orange,
    Colors.lightBlue,
    Colors.blueAccent,
    Colors.indigo,
    Colors.lightGreen,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.brown,
    Colors.black,
    Colors.black12,
    Colors.black87,
    Colors.black45,
    Colors.black54,
    Colors.black38,
    Colors.black26,
    Colors.white,
    Colors.white10,
    Colors.white12,
    Colors.white54,
    Colors.white70,
    Colors.white24,
    Colors.white38,
    Colors.white60,
    Colors.white30,
  ];
  var PhoneInvite = TextEditingController();
  var Scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool t = false;
    bool ShowPrivacy = false;
    return BlocConsumer<ChatCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialUploadFileSuccessStates) {
          ScaffoldMessenger.of(context).showSnackBar(
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
                      child: Text("The privacy updated Successfully"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is SocialUploadFileErrorStates) {
          ScaffoldMessenger.of(context).showSnackBar(
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
      },
      builder: (context, state) {
        return Scaffold(
          key: Scaffoldkey,
          body: Container(
            color: !isDark ? Color(0xFFECF0F3) : Color(0),
            //color: const Color(0xFFECF0F3),
            child: ListView(
              children: [
                if (state is SocialUpdateUserPrivacyLoadingStates)
                  LinearProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF84a59d),
                      elevation: 0,
                    ),
                    child: const Text('Change the font size ?'),
                    onPressed: () {
                      !t
                          ? t = ChatCubit.get(context).ChangeVar(t, true)
                          : t = ChatCubit.get(context).ChangeVar(t, false);
                    },
                  ),
                ),
                if (t)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<double>(
                      elevation: 15,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      hint: !ChatCubit.get(context).fontS.contains(fontSize)
                          ? const Text(
                              'Select the font Size',
                            )
                          : Text(fontSize.toString()),
                      items: ChatCubit.get(context).fontS.map((double value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        ChatCubit.get(context).ChangeFont(newValue as double);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF84a59d),
                      elevation: 0,
                    ),
                    child: const Text('Change wallPaper ?'),
                    onPressed: () {
                      var e = AlertDialog(
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('cansel'))
                        ],
                        title: Text('Choose Color'),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        content: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 90,
                              mainAxisSpacing: 5,
                              childAspectRatio: 3 / 2,
                            ),
                            itemCount: colors.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  onTap: () async {
                                    //         print(colors[index].toString());
                                    //       await Shard.saveData(
                                    //         key: 'ColorWall',
                                    //       value: colors[index].toString());
                                    //     WallPaperColor = Shard.sharedprefrences!
                                    //          .getString('ColorWall');
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: colors[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                      showDialog(context: context, builder: (context) => e);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF84a59d),
                      elevation: 0,
                    ),
                    child: const Text('Privacy'),
                    onPressed: () {
                      !ShowPrivacy
                          ? ShowPrivacy = ChatCubit.get(context)
                              .ChangeVar(ShowPrivacy, true)
                          : ShowPrivacy = ChatCubit.get(context)
                              .ChangeVar(ShowPrivacy, false);
                    },
                  ),
                ),
                if (ShowPrivacy)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      elevation: 15,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      hint: !ChatCubit.get(context).Phone.contains(
                              ChatCubit.get(context)
                                  .privacySelectionPhoneNumber)
                          ? const Text(
                              'Phone Number',
                            )
                          : Text('Phone Number : ' +
                              ChatCubit.get(context)
                                  .privacySelectionPhoneNumber
                                  .toString()),
                      items: ChatCubit.get(context).Phone.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        ChatCubit.get(context)
                            .ChangeVarPrivacyPhoneNumber(newValue!);
                      },
                    ),
                  ),
                if (ShowPrivacy)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      elevation: 15,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      hint: !ChatCubit.get(context).profilePictures.contains(
                              ChatCubit.get(context)
                                  .privacySelectionProfilePicture)
                          ? const Text(
                              'Profile Picture',
                            )
                          : Text('Profile Picture : ' +
                              ChatCubit.get(context)
                                  .privacySelectionProfilePicture
                                  .toString()),
                      items: ChatCubit.get(context)
                          .profilePictures
                          .map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        ChatCubit.get(context)
                            .ChangeVarPrivacyProfilePicture(newValue!);
                      },
                    ),
                  ),
                if (ShowPrivacy)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      elevation: 15,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      hint: !ChatCubit.get(context).coverPictures.contains(
                              ChatCubit.get(context)
                                  .privacySelectionCoverPictures)
                          ? const Text(
                              'Cover Picture',
                            )
                          : Text('Cover Picture : ' +
                              ChatCubit.get(context)
                                  .privacySelectionCoverPictures
                                  .toString()),
                      items: ChatCubit.get(context)
                          .coverPictures
                          .map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        ChatCubit.get(context)
                            .ChangeVarPrivacyCoverPictures(newValue!);
                      },
                    ),
                  ),
                if (ShowPrivacy)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      elevation: 15,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      hint: !ChatCubit.get(context).Bio.contains(
                              ChatCubit.get(context).privacySelectionBio)
                          ? const Text(
                              'Bio',
                            )
                          : Text('Bio : ' +
                              ChatCubit.get(context)
                                  .privacySelectionBio
                                  .toString()),
                      items: ChatCubit.get(context).Bio.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        ChatCubit.get(context).ChangeVarPrivacyBio(newValue!);
                      },
                    ),
                  ),
                if (ShowPrivacy)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      elevation: 15,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      hint: !ChatCubit.get(context).emailAdr.contains(
                              ChatCubit.get(context)
                                  .privacySelectionEmailAddress)
                          ? const Text(
                              'Email Address',
                            )
                          : Text('email address : ' +
                              ChatCubit.get(context)
                                  .privacySelectionEmailAddress
                                  .toString()),
                      items:
                          ChatCubit.get(context).emailAdr.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) async {
                        ChatCubit.get(context)
                            .ChangeVarPrivacyEmailAddress(newValue!);
                      },
                    ),
                  ),
                if (ShowPrivacy)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        elevation: 0,
                      ),
                      child: const Text(' Save ? '),
                      onPressed: () {
                        ChatCubit.get(context).UpdateUserPrivacy();
                      },
                    ),
                  ),
                if (ShowPrivacy) const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF84a59d),
                      elevation: 0,
                    ),
                    child: Text(isDark ? 'light mode?' : 'dark mode?'),
                    onPressed: () {
                      isDark
                          ? ChatCubit.get(context).SavedDark(isDark, false)
                          : ChatCubit.get(context).SavedDark(isDark, true);
                      if (Shard.sharedprefrences!.getBool('darkMode') != null)
                        isDark = Shard.sharedprefrences!.getBool('darkMode')!;
                      main();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF84a59d),
                      elevation: 0,
                    ),
                    child: const Text('Contact with us'),
                    onPressed: () {
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return Container(
                            color: isDark ? Color(0) : Color(0xFFECF0F3),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () {
                                          ChatCubit.get(context).LaunchUrl(
                                              'https://facebook.com/ahmad.alfrehan80');
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.facebook,
                                                color: Colors.blue),
                                            const SizedBox(
                                              width: 40,
                                            ),
                                            Text('facebook')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        ChatCubit.get(context).makeEmailCall(
                                            'ahmadfrehan333@gmail.com');
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.email, color: Colors.red),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          Text('Email')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        ChatCubit.get(context).LaunchUrl(
                                          'https://t.me/ahmad_al_frehan',
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.telegram,
                                              color: Colors.blue),
                                          const SizedBox(
                                            width: 40,
                                          ),
                                          Text('Telegram')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 40),
                                const Divider(
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 40),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      ChatCubit.get(context).LaunchUrl(
                                          'https://play.google.com/store/apps/details?id=com.ahmad_alfrehan.imagin_true');
                                    },
                                    child: Text(
                                      'check for updates ?',
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF84a59d),
                      elevation: 0,
                    ),
                    child: const Text(' invite some one ?'),
                    onPressed: () {
                      Scaffoldkey.currentState!
                          .showBottomSheet(
                            (context) => Scaffold(
                              body: Container(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TextFormField(
                                        controller: PhoneInvite,
                                        decoration: InputDecoration(
                                          label: const Text(
                                              "write the phone number"),
                                          filled: true,
                                          enabled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'the field must not be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        ChatCubit.get(context)
                                            .makeMessage(PhoneInvite.text);
                                      },
                                      child: const Text('invite'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .closed;

                      //
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 0,
                    ),
                    child: const Text('Delete the account ?'),
                    onPressed: () {
                      //ChatCubit.get(context).makeMessage('+963982867881');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: isDark ? Colors.grey.shade600 : Colors.white,
                      elevation: 0,
                    ),
                    child: Text('LogOut?',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        )),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
