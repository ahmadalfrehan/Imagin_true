import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Chat/Cubit/cubit.dart';
import '../Chat/Cubit/states.dart';
import '../EditP/EditProfileScreen.dart';
import '../login/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var UserModel = ChatCubit.get(context).UU;
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()..getUsers(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (UserModel == null)
            return const Center(
              child: const Text(''),
            );
          return Container(
            child: state is SocialGetUserLoadingStates
                ? const LinearProgressIndicator()
                : ListView(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(UserModel.Cover.toString()),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: (size.width * 0.3) - 1,
                                left: (size.width * 0.34) - 10),
                            child: CircleAvatar(
                              radius: 84,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                  UserModel.ImageProfile.toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                UserModel.name.toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            UserModel.Bio.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    //print(SociallCubit.get(context).UU!.name.toString());
                                    print(UserModel.toString());
                                    print(UserModel.name);

                                    print(UserModel.Bio);
                                  },
                                  child: Column(
                                    children: const [
                                      Text(
                                        "100",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "posts",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: const [
                                      Text(
                                        "100",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Photos",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: const [
                                      Text(
                                        "100 K",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Followers",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: const [
                                      Text(
                                        "60",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Following",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.person_add,
                                          size: 25,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          " Add Friend",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                OutlinedButton(
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
                                        iconMargin: const EdgeInsets.symmetric(
                                            horizontal: 15),
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
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        child: const Text('LogOut?'),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

/*Container(
                        child: Column(
                      children: [
                        const Divider(
                          indent: 12,
                          endIndent: 12,
                          color: Colors.black26,
                        ),
                        const SizedBox(height: 12),
                        Detalis(
                            " Studies ITE at جامعة دمشق Damascus \n University",
                            Icons.school),
                        Detalis(" Studied ITE at Aleppo of University",
                            Icons.school),
                        //Detalis("Went toثانوية جاسم الرسمية ", Icons.school),
                        //Detalis("Went toثانوية نوى الخاصة ", Icons.school),
                        Detalis("Lives in Dar`a", Icons.home_work_rounded),
                        Detalis("From Dar`a", Icons.fmd_good_sharp),
                        Detalis("Single", Icons.favorite),
                        Detalis("Joined July 2015", Icons.access_time_filled),
                        Detalis("Followed by 158 people", Icons.subscriptions),
                        Detalis("t.me/Ahmad_ALFrehan", Icons.link),
                        Detalis(
                            "codeforces.com/profile/AhmadFrehan", Icons.link),
                        Detalis("Seeأحمد's About Info", Icons.more_horiz),
                        const Divider(
                          color: Colors.black26,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Friends",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 12,
                          // color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Posts",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Divider(
                          thickness: 12,
                        ),
                      ],
                    ))*/
  Row Detalis(String s, IconData e) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Icon(
          e,
          size: 25,
          color: Colors.black,
        ),
        MaterialButton(
          onPressed: () {},
          child: Text(
            s,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
