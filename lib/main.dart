import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_pterodactyls_away/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: "Keep Pterodactyls Away",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.deepOrange,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.deepOrange),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Keep Pterodactyls Away"),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.info_outline),
                  tooltip: "Info",
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
              TextButton(
                child: Text("Check"),
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
