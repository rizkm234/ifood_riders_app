import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data ;
  final String? hintText;
  bool? isObscure = true;
  bool? enabled = true;

   CustomTextField({Key? key,
     this.controller,
     this.data,
     this.hintText,
     this.isObscure,
     this.enabled,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObscure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(data , color: Colors.cyan,),
          hintText: hintText,
          focusColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
