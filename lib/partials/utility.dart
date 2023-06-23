// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, camel_case_types, no_logic_in_create_state, avoid_print

import 'dart:convert';
import 'package:crypto/home.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/auth/login.dart';
import 'light_colors.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class Utility {
  String baseUrl() {
    return "https://myusdt.my/public/uploads/mobile_app/";
  }

  String siteUrl() {
    return "https://myusdt.my/public/uploads/";
  }

  String websiteUrl() {
    return "https://myusdt.my/";
  }

  String strToMoney(amount) {
    return double.parse(amount).toStringAsFixed(4);
  }

  String strToCommaMoney(amount) {
    var formatter = NumberFormat('###,###,###');
    return formatter.format(amount);
  }

  /*
  String removeMoneyComma(amount) {
    return amount.toString().replaceAll(",", "");
  }
  */

  String getTotalString(amount, unit) {
    int unit2 = unit.isEmpty ? 0 : int.parse(unit);
    double total = double.parse(amount) * unit2;
    return "$amount x $unit2 = ${strToMoney(total.toString())}";
  }

  Future<bool> onWillPop(context) async {
    Future<bool> closeApp = confirmationDialog(context, "Exit App ?");

    if (await closeApp == true) {
      SystemNavigator.pop();
    }
    return Future.value(false);
  }

  void clearSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void logout(context) {
    // go to login screen
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: Text("Logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: Text("Are you sure you want to Logout?",
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins')),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  clearSharedPrefs();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainScreen(
                                customer: {},
                              )));
                  toast("Log out success.");
                },
                style: TextButton.styleFrom(
                  elevation: 5,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: LightColors.kDarkGreen,
                ),
                child: Text("Yes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins')),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  elevation: 5,
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white,
                ),
                child: Text("No",
                    style: TextStyle(
                        color: LightColors.kDarkGreen,
                        fontSize: 16,
                        fontFamily: 'Poppins')),
              ),
            ],
          );
        });
  }

  void infoDialog(
    context,
    title,
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: LightColors.kGrey,
            title: Text(title),
            content: SizedBox(
              height: 10,
            ),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(LightColors.kDarkBlue),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ))),
                child: Text("Okay"),
              ),
            ],
          );
        });
  }

  Future<bool> confirmationDialog(context, message) async {
    bool confirm = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: LightColors.kGrey,
                title: Text(message),
                content: SizedBox(
                  height: 10,
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Yes"),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            LightColors.kDarkBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No"),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            LightColors.kDarkBlue),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ))),
                  ),
                ],
              );
            }) ??
        false;

    return confirm;
  }

  Widget empty(double screenHeight) {
    return Container(alignment: Alignment.center, child: Text("-- Empty --"));
  }

  Widget changeProfilePicture(url) {
    return url.isEmpty
        ? Container()
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(url))),
          );
  }

  bool isJson(data) {
    var decodeSucceeded = false;

    try {
      var decodedJSON = json.decode(data) as Map<String, dynamic>;
      decodeSucceeded = true;
      print('The provided data is JSON');
    } on FormatException catch (e) {
      decodeSucceeded = false;
      print('The provided data is not JSON');
    }

    return decodeSucceeded;
  }

  bool isMap(data) {
    var decodeSucceeded = false;

    try {
      var decodedJSON = jsonDecode(data);
      decodeSucceeded = true;
      print('The provided data is Map');
    } on FormatException catch (e) {
      decodeSucceeded = false;
      print('The provided data is not Map');
    }

    return decodeSucceeded;
  }

  void toast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void pop(context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /*
  void dialog(context, message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: LightColors.kPink,
            )
          ),
        );
      }
    ) ?? false;;
  }
  */

  void dialog(context, message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          title: Row(
        children: [
          CircularProgressIndicator(
            color: LightColors.kLightPurple,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
        ],
      )),
    );
  }

  void displaySinglePicture(context, source, pic) {
    // 1-AssetImage, 2-Internet

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          image: source == 1
                              ? DecorationImage(image: AssetImage(pic))
                              : DecorationImage(image: NetworkImage(pic))),
                    ),
                    onTap: () => pop(context),
                  ),
                )
              ],
            ),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          );
        });
  }

  Future<bool> exitApplication(currentBackPressTime) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toast("Press one more time to exit application.");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future exitApplication2(currentBackPressTime) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toast("Press back again to exit");
      return Future.value(false);
    }
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
