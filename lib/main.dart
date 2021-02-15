import 'dart:developer';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_pterodactyls_away/Service.dart';
import 'package:keep_pterodactyls_away/info.dart';
import 'package:workmanager/workmanager.dart' as wm;

Future<void> check() async {
  // Why 13? Why not.
  final int value = Random().nextInt(1000 - 13) + 13;

  const platform = const MethodChannel("notification");

  await platform.invokeMethod("sendNotification", { "value": value.toString() });
}

void callbackDispatcher() {
  wm.Workmanager.executeTask((task, inputData) async {
    await check();

    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await wm.Workmanager.initialize(callbackDispatcher);

  final Service service = new Service();

  await service.restoreStatus();

  runApp(
    EasyLocalization(
      supportedLocales: [
        const Locale("it"),
        const Locale("en"),
      ],
      path: "assets/translations",
      fallbackLocale: Locale("en"),
      child: MyApp(service),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Service _service;

  MyApp(this._service);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: "title".tr(),
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
            padding: MaterialStateProperty.all(EdgeInsets.all(15)),
            textStyle: MaterialStateProperty.all(TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
            shape: MaterialStateProperty.all(StadiumBorder()),
          ),
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      home: Scaffold(
        appBar: AppBar(
          title: Text("title".tr()),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "service".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      widget._service.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset("assets/pterodactyl.svg"),
              Container(
                width: double.infinity,
                child: TextButton.icon(
                  icon: Icon(
                    widget._service.enabled
                      ? Icons.remove_moderator
                      : Icons.shield
                  ),
                  label: Text(
                    widget._service.enabled
                      ? "disableService".tr()
                      : "enableService".tr()
                  ),
                  onPressed: () async {
                    await widget._service.changeStatus();

                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
