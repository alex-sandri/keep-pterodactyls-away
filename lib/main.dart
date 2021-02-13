import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    "Allontana gli Pterodattili",
    "Hai scacciato $value pterodattili",
    NotificationDetails(
      android: AndroidNotificationDetails(
        "0",
        "Notifiche",
        "Notifiche",
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
    "fetchMessages",
    "fetchMessages",
    frequency: Duration(hours: 13),
  );

  runApp(MyApp());
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("it"),
        const Locale("en"),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text("Allontanta gli Pterodattili"),
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
                      child: Text(_service.enabled ? "Disabilita servizio" : "Abilita servizio"),
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
