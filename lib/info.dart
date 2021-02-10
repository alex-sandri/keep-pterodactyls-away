import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: Text("Info"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeumorphicText(
                "Image Credit",
                style: NeumorphicStyle(
                  color: Colors.black,
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              NeumorphicText(
                "Darius Dan from www.flaticon.com",
                style: NeumorphicStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
