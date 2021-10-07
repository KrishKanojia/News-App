import 'package:flutter/material.dart';

import '../constraints.dart';

class PasswordTextFormField extends StatelessWidget {
  late String name;
  TextEditingController controller = TextEditingController();
  late VoidCallback onTap;
  late bool obscureText;
  late Icon myIcon;

  PasswordTextFormField({
    required this.name,
    required this.obscureText,
    required this.onTap,
    required this.controller,
    required this.myIcon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: myIcon,
          filled: true,
          fillColor: Colors.grey[200],
          hintStyle: TextStyle(color: kprimary, fontSize: 17),
          hintText: name,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none),
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: obscureText == true
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
          ),
        ),
      ),
    );
  }
}
