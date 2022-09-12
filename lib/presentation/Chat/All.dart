import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/presentation/Chat/Cubit/states.dart';
import '../../app/Config/Config.dart';
import '../../data/model/UsersModel.dart';
import 'Cubit/cubit.dart';
import 'Cubit/states.dart';
import 'chat_details.dart';

class AllU extends StatelessWidget {
  AllU();

  List allusers = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit()
        ..getUsers()
        ..getAllUsersWithOutRelat(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SocialGetAllUserLoadingStates ||
              ChatCubit.get(context).Allusers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: Container(
              color: !isDark ? Color(0xFFECF0F3) : Color(0xff),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: ChatCubit.get(context).Allusers.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) => INK(
                  ChatCubit.get(context).Allusers[index],
                  context,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget INK(UsersModel users, context) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailes(users),
            ),
          );
          ChatCubit.get(context).scrolltoDown();
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(users.ImageProfile.toString()),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                users.name.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
