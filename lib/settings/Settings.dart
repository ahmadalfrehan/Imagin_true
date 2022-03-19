import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagin_true/Chat/Cubit/cubit.dart';
import 'package:imagin_true/sharedHELper.dart';
import '../Chat/Cubit/states.dart';
import '../login/login_screen.dart';

class SettingsS extends StatelessWidget {
  const SettingsS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Container(
              color: const Color(0xFFECF0F3),
              child: ListView(
                children: [
                  DropdownButton<double>(
                    elevation: 15,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    hint: !ChatCubit.get(context)
                            .fontS
                            .contains(ChatCubit.get(context).FontSized)
                        ? const Text(
                            'Select the font Sized please',
                          )
                        : Text(ChatCubit.get(context).FontSized.toString()),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 0,
                      ),
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
