import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keep_pterodactyls_away/Service.dart';
import 'package:keep_pterodactyls_away/info.dart';
import 'package:workmanager/workmanager.dart' as wm;

Future<void> check() async {
  FlutterLocalNotificationsPlugin().show(0, "title", "body", NotificationDetails(
    android: AndroidNotificationDetails(
      "0",
      "Notifications",
      "Notifications",
    ),
    iOS: IOSNotificationDetails(),
  ));
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
    frequency: Duration(minutes: 15),
  );

  check();

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
                      child: Text(_service.enabled ? "Disable service" : "Enable service"),
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
