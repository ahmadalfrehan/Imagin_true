import 'package:flutter/material.dart';

import '../../app/Config/Config.dart';

class ShowBottom {
  static showBottom(var scaffoldKey, TextEditingController resetController,
      Function function) {
    scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        child: SizedBox(
          height: 240,
          width: double.infinity,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                controller: resetController,
                decoration: InputDecoration(
                  label: const Text("reset"),
                  fillColor: Colors.white,
                  filled: isDark ? false : true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'this field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            TextButton(
              onPressed: () {
                function;
              },
              child: Text('send'),
            ),
          ]),
        ),
      ),
    );
  }
}
