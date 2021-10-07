import 'package:flutter/material.dart';

import '../constraints.dart';

class MyTextFormField extends StatelessWidget {
  late String name;
  late Icon myIcon;
  late TextEditingController controller;

  MyTextFormField({
    required this.name,
    required this.myIcon,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      // color: Colors.green,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.grey[200],
          hintStyle: TextStyle(color: kprimary, fontSize: 17),
          hintText: name,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none),
          prefixIcon: myIcon,
        ),
      ),
    );
  }
}
