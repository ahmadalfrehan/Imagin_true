import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/Earth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Chat/Cubit/cubit.dart';
import '../Chat/Cubit/states.dart';

class Contactss extends StatelessWidget {
  const Contactss({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getUsersAll(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: ChatCubit.get(context).contactslist != null
                ? Container(
                    color: const Color(0xFFECF0F3),
                    child: ListView.builder(
                      itemCount:
                          ChatCubit.get(context).contactslist?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Contact? contact = ChatCubit.get(context)
                            .contactslist
                            ?.elementAt(index);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 18),
                          leading: (contact!.avatar != null &&
                                  contact.avatar!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(contact.avatar as Uint8List),
                                )
                              : CircleAvatar(
                                  child: Text(contact.initials()),
                                  backgroundColor: Theme.of(context).cardColor,
                                ),
                          title: Text(contact.displayName ?? ''),
                        );
                      },
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
