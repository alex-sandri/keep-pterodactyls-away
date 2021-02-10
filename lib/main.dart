import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_pterodactyls_away/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      title: "Keep Pterodactyls Away",
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        appBarTheme: NeumorphicAppBarThemeData(
          buttonStyle: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
          ),
        ),
        buttonStyle: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(5)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: NeumorphicAppBar(
          title: NeumorphicText(
            "Keep Pterodactyls Away",
            style: NeumorphicStyle(
              color: Colors.black,
            ),
            textStyle: NeumorphicTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Builder(
              builder: (context) {
                return NeumorphicButton(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.info_outline,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Info(),
                    ));
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/pterodactyl.svg"),
              NeumorphicButton(
                padding: const EdgeInsets.all(12),
                child: NeumorphicText(
                  "Check",
                  style: NeumorphicStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  // TODO
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
