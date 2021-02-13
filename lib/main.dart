import 'dart:developer';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_pterodactyls_away/Service.dart';
import 'package:keep_pterodactyls_away/info.dart';
import 'package:workmanager/workmanager.dart' as wm;

Future<void> check() async {
  final Service _service = new Service();

  await _service.restoreStatus();

  if (!_service.enabled) return;

  // Why 13? Why not.
  final int value = Random().nextInt(1000 - 13) + 13;

  FlutterLocalNotificationsPlugin().show(
    0,
    "title".tr(),
    "notificationBody".tr(namedArgs: { "number": value.toString() }),
    NotificationDetails(
      android: AndroidNotificationDetails(
        "0",
        "notifications".tr(),
        "notifications".tr(),
      ),
      iOS: IOSNotificationDetails(),
    ),
  );
}

void callbackDispatcher() {
  wm.Workmanager.executeTask((task, inputData) async {
    await check();

    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    iOS: IOSInitializationSettings(),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) => null,
  );

  wm.Workmanager.initialize(callbackDispatcher);

  wm.Workmanager.registerPeriodicTask(
    "check",
    "check",
    frequency: Duration(hours: 13),
  );

  runApp(
    EasyLocalization(
      supportedLocales: [
        const Locale("it"),
        const Locale("en"),
      ],
      path: "assets/translations",
      fallbackLocale: Locale("en"),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Service _service = new Service();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

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
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
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
        body: FutureBuilder<void>(
            future: _service.restoreStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();

              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _service.status,
                      style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SvgPicture.asset("assets/pterodactyl.svg"),
                    TextButton(
                      child: Text(
                        _service.enabled
                          ? "disableService".tr()
                          : "enableService".tr()
                      ),
                      onPressed: () async {
                        await _service.changeStatus();

                        setState(() {});
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
