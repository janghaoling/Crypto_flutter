// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, prefer_interpolation_to_compose_strings
import 'dart:convert';
//import 'package:wwp/login.dart';
//import 'package:wwp/object/staff.dart';
import 'package:crypto/partials/app_theme2.dart';
import 'package:crypto/utils/navigator_key.dart';
import 'package:flutter/scheduler.dart';

import 'home.dart';
import 'auth/login.dart';
import 'partials/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/partials/light_colors.dart';
import 'package:crypto/home.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: FitnessAppTheme.fontName,
          primaryColor: Colors.black,
        ),
        home: SplashScreen(),
        builder: EasyLoading.init(),
        key: navigatorKey,
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late double screenHeight, screenWidth;
  Utility util = Utility();

  void iniState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Stack(
          children: [
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: LightColors.kEmerald,
              ),
            ),
            Center(
              child: FadeInImage(
                height: screenHeight * 0.3,
                placeholder: AssetImage("assets/images/transparent.png"),
                image: AssetImage("assets/images/logo.png"),
              ),
            ),
            ProgressIndicator()
          ],
        )));
  }
}

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({Key? key}) : super(key: key);

  @override
  ProgressIndicatorState createState() => ProgressIndicatorState();
}

class ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late bool
      haveSharedPrefs; // to indicate if user have requested to save email & password before
  late String email, password; // to save email & password
  bool loaded = false; // to stop the progress indicator
  Utility util = Utility();

  @override
  void initState() {
    super.initState();

    autoLogin();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.00).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99 && loaded == false) {
            // if loading reach 99%, perform login request
            loaded = true;

            if (haveSharedPrefs == true) {
              // if there are shared preference record, directly login
              String loginUrl = "${util.baseUrl()}profile.php";
              try {
                http.post(Uri.parse(loginUrl), body: {
                  "operation": "login",
                  "email": email,
                  "password": password,
                }).then((res) {
                  if (!util.isMap(res.body)) {
                    clearSharedPrefs();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(
                                  customer: {},
                                )));
                  } else if (util.isMap(res.body)) {
                    Map customer = jsonDecode(res.body)['customer'][0];

                    util.toast("${"Hello " + customer['name']} !");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(
                                  customer: customer,
                                )));
                  } else {
                    util.toast(res.body);
                  }
                }).catchError((error) {
                  util.toast("Error occured:$error");
                });
              } on Exception catch (error) {
                util.toast("Error occured:$error");
              }
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(
                            customer: {},
                          )));
            }
          }
        });
      });
    controller.repeat();
  }

  /* This method is to check if there are any shared preference record saved. */
  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = (prefs.getString("email")) ?? "";
    password = (prefs.getString("password")) ?? "";
    haveSharedPrefs = false;

    if (email.isNotEmpty) {
      haveSharedPrefs = true;
    }
  }

  void clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void dialog(msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          title: Row(
        children: [
          CircularProgressIndicator(
            color: LightColors.kPurple,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            msg,
            style: TextStyle(fontSize: 16),
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(0, -0.6),
        child: CircularProgressIndicator(
          value: animation.value,
          strokeWidth: 8,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
        ));
  }
}
