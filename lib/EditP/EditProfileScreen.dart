import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Chat/Cubit/cubit.dart';
import '../Chat/Cubit/states.dart';

class EditProfile extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()..getUsers(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var UserModell = ChatCubit.get(context).UU;
          File? image = ChatCubit.get(context).imageProfile;
          if (UserModell != null) {
            nameController.text = UserModell.name.toString();
            phoneController.text = UserModell.phone.toString();
            bioController.text = UserModell.Bio.toString();
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).bottomAppBarColor,
              actions: [
                MaterialButton(
                  onPressed: () {
                    ChatCubit.get(context).UpdateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                    print(ChatCubit.get(context).imageProfile);
                  },
                  child: const Text("save"),
                ),
              ],
            ),
            body: Container(
              child: ListView(
                children: [
                  if (state is SocialUpdateUserLoadingStates)
                    const LinearProgressIndicator(),
                  if (state is SocialUpdateUserLoadingStates)
                    const SizedBox(
                      height: 4,
                    ),
                  Stack(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: UserModell != null
                                    ? NetworkImage(UserModell.Cover.toString())
                                    : const NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/chat-25714.appspot.com/o/users%2Fimage_picker7821665999907165931.jpg?alt=media&token=dbbcfd8e-d8b6-4e41-9258-757ff34d7794'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ChatCubit.get(context)
                                  .getImageCover(ImageSource.gallery);
                            },
                            child: const CircleAvatar(
                              child: Icon(Icons.camera_alt_outlined),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: (size.width * 0.3) - 1,
                            left: (size.width * 0.34) - 10),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 84,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: UserModell != null
                                    ? NetworkImage(
                                        UserModell.ImageProfile.toString())
                                    : const NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/chat-25714.appspot.com/o/users%2Fimage_picker7821665999907165931.jpg?alt=media&token=dbbcfd8e-d8b6-4e41-9258-757ff34d7794'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ChatCubit.get(context)
                                    .getImageProfile(ImageSource.gallery);
                              },
                              child: const CircleAvatar(
                                child: Icon(Icons.camera_alt_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (ChatCubit.get(context).imageProfile != null ||
                      ChatCubit.get(context).imageCover != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (ChatCubit.get(context).imageProfile != null)
                            Expanded(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      ChatCubit.get(context)
                                          .uploadProfileImage();
                                    },
                                    child: const Text('update profile'),
                                  ),
                                  if (state
                                      is SocialUploadImageProfileLoadingStates)
                                    LinearProgressIndicator(),
                                ],
                              ),
                            ),
                          const SizedBox(
                            width: 5,
                          ),
                          if (ChatCubit.get(context).imageCover != null)
                            Expanded(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      ChatCubit.get(context).uploadCoverImage();
                                    },
                                    child: const Text('update cover ?'),
                                  ),
                                  if (state
                                      is SocialUploadImageCoverLoadingStates)
                                    LinearProgressIndicator(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(

                          controller: nameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            labelText: "name",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            labelText: "phone",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          controller: bioController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(
                                  color: Colors.green, width: 2.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            labelText: "Bio",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
