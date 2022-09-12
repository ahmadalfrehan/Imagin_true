import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/presentation/Chat/Cubit/states.dart';

import '../../app/Config/Config.dart';
import '../Chat/Cubit/cubit.dart';
import '../EditP/EditProfileScreen.dart';
import '../login/login_screen.dart';

class Earth extends StatelessWidget {
  const Earth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsersUseCase(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: isDark ? Color(0xff) : Color(0xFFECF0F3),
              title: !FirebaseAuth.instance.currentUser!.emailVerified
                  ? Container(
                      height: 60,
                      color: Colors.amber.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2, left: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline),
                            SizedBox(
                              width: 8,
                            ),
                            const Expanded(
                              child: Text(
                                'verify your account To continue using this app',
                              ),
                            ),
                            Row(
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                  },
                                  child: const Text('Send?'),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('logOut?'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(
                      ChatCubit.get(context)
                          .titles[ChatCubit.get(context).Cindex],
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                    ),
              actions: [
                if (ChatCubit.get(context)
                        .titles[ChatCubit.get(context).Cindex] ==
                    'My Profile')
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tab(
                          height: 25,
                          iconMargin:
                              const EdgeInsets.symmetric(horizontal: 15),
                          icon: Container(
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            body: Container(
              color: isDark ? Color(0) : Color(0xFFECF0F3),
              child:
                  ChatCubit.get(context).screens[ChatCubit.get(context).Cindex],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              index: ChatCubit.get(context).Cindex,
              onTap: (index) {
                ChatCubit.get(context).ChangeBottomSheet(index);
              },
              color: isDark ? Colors.grey.shade700 : Colors.white,
              //color: Colors.white,
              buttonBackgroundColor: isDark ? Colors.black : Colors.white,
              backgroundColor: isDark ? Color(0xff) : Color(0xFFECF0F3),
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 600),
              items: const [
                Icon(Icons.chat),
                Icon(Icons.group_rounded),
                Icon(Icons.contacts),
                Icon(Icons.person_pin_rounded),
                Icon(Icons.settings),
              ],
            ),
          );
        },
      ),
    );
  }
}
