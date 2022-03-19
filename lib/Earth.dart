import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Chat/Cubit/cubit.dart';
import 'Chat/Cubit/states.dart';
import 'EditP/EditProfileScreen.dart';

class Earth extends StatelessWidget {
  const Earth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getContacts(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFECF0F3),
              title: Text(
                  ChatCubit.get(context).titles[ChatCubit.get(context).Cindex]),
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
              color: const Color(0xFFECF0F3),
              child:
                  ChatCubit.get(context).screens[ChatCubit.get(context).Cindex],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              index: ChatCubit.get(context).Cindex,
              onTap: (index) {
                ChatCubit.get(context).ChangeBottomSheet(index);
              },
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: const Color(0xFFECF0F3),
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 600),
              items: const [
                Icon(Icons.chat),
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
