// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/auth/login.dart';
import 'package:crypto/partials/app_theme2.dart';
import 'package:crypto/partials/dropdown.dart';
import 'package:crypto/partials/utility.dart';
import 'package:crypto/auth/register.dart';
import 'package:crypto/utils/custom_style.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'partials/light_colors.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MainScreen extends StatefulWidget {
  final Map customer;
  const MainScreen({Key? key, required this.customer}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double screenWidth, screenHeight;
  Utility util = Utility();
  List showItems = [];
  String sell_price = "0";
  var sell_price_format = NumberFormat('#,##,000');
  Map setting = {};
  Timer? timer;
  late List history = [];

  File? picture;
  List attachmentNames = [];
  List attachmentExt = [];
  List<File> attachmentFiles = [];

  // Buy
  TextEditingController total_buy_tec = TextEditingController();
  TextEditingController unit_buy_tec = TextEditingController();
  TextEditingController wallet_tec = TextEditingController();
  // Buy

  // Sell
  TextEditingController total_sell_tec = TextEditingController();
  TextEditingController unit_sell_tec = TextEditingController();
  String bank_tec = "";
  TextEditingController acc_tec = TextEditingController();
  List banks = [
    {"parameter": "Please Select", "value": ""},
    {"parameter": "Affin Bank Berhad", "value": "Affin Bank Berhad"},
    {"parameter": "Agrobank", "value": "Agrobank"},
    {
      "parameter": "Al Rajhi & Investment Corporation(Malaysia) Berhad",
      "value": "Al Rajhi & Investment Corporation(Malaysia) Berhad"
    },
    {
      "parameter": "Alliance Bank Malaysia Berhad",
      "value": "Alliance Bank Malaysia Berhad"
    },
    {"parameter": "Ambank Berhad", "value": "Ambank Berhad"},
    {
      "parameter": "Bank Kerjasama Rakyat Malaysia Berhad",
      "value": "Bank Kerjasama Rakyat Malaysia Berhad"
    },
    {
      "parameter": "Bank Muamalat Malaysia Berhad",
      "value": "Bank Muamalat Malaysia Berhad"
    },
    {
      "parameter": "Bank of America (Malaysia) Berhad",
      "value": "Bank of America (Malaysia) Berhad"
    },
    {
      "parameter": "Bank of China (Malaysia) Berhad",
      "value": "Bank of China (Malaysia) Berhad"
    },
    {"parameter": "Bank Simpanan Nasional", "value": "Bank Simpanan Nasional"},
    {
      "parameter": "China Construction Bank (Malaysia) Berhad",
      "value": "China Construction Bank (Malaysia) Berhad"
    },
    {"parameter": "CIMB Bank Berhad", "value": "CIMB Bank Berhad"},
    {"parameter": "Citibank Berhad", "value": "Citibank Berhad"},
    {
      "parameter": "Deutsche Bank (Malaysia) Berhad",
      "value": "Deutsche Bank (Malaysia) Berhad"
    },
    {"parameter": "Hong Leong Bank Berhad", "value": "Hong Leong Bank Berhad"},
    {
      "parameter": "HSBC Bank Malaysia Berhad",
      "value": "HSBC Bank Malaysia Berhad"
    },
    {
      "parameter": "JP Morgan Chase Bank Berhad",
      "value": "JP Morgan Chase Bank Berhad"
    },
    {"parameter": "Maybank Berhad", "value": "Maybank Berhad"},
    {"parameter": "MBSB Bank Berhad", "value": "MBSB Bank Berhad"},
    {
      "parameter": "Mizuho Bank (Malaysia) Berhad",
      "value": "Mizuho Bank (Malaysia) Berhad"
    },
    {
      "parameter": "MUFG Bank (Malaysia) Berhad",
      "value": "MUFG Bank (Malaysia) Berhad"
    },
    {
      "parameter": "OCBC Bank (Malaysia) Berhad",
      "value": "OCBC Bank (Malaysia) Berhad"
    },
    {"parameter": "Public Bank Berhad", "value": "Public Bank Berhad"},
    {"parameter": "RHB Bank Berhad", "value": "RHB Bank Berhad"},
    {
      "parameter": "Standard Chartered Bank Malaysia Berhad",
      "value": "Standard Chartered Bank Malaysia Berhad"
    },
    {
      "parameter": "Sumitomo Mitsui Bank Corporation",
      "value": "Sumitomo Mitsui Bank Corporation"
    },
    {
      "parameter": "United Overseas Bank Berhad",
      "value": "United Overseas Bank Berhad"
    },
  ];
  // Sell

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late DateTime currentBackPressTime;

  String? pickfile;
  String? pickfileCamera;

  @override
  void initState() {
    loadSetting();
    loadHistory();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => loadSetting());
    unit_buy_tec.text = "1";
    unit_sell_tec.text = "1";
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () => util.onWillPop(context),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: null,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  snap: true,
                  floating: true,
                  leading: Container(),
                  collapsedHeight: screenHeight * 0.22,
                  expandedHeight: screenHeight * 0.35,
                  backgroundColor: LightColors.kDarkGreen,
                  shadowColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Tether USDT (TRC20)",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: FitnessAppTheme.fontName,
                              fontSize: screenHeight * 0.02),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                buyDialog();
                              },
                              child: Container(
                                height: 35,
                                width: screenWidth * 0.15,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: LightColors.kDarkGreen.withOpacity(1),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Text(
                                  "Buy",
                                  style: TextStyle(
                                    fontSize: screenHeight * 0.025,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FitnessAppTheme.fontName,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              " RM ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontSize: screenHeight * 0.025),
                            ),
                            Text(
                              setting['buy'].toString().isEmpty
                                  ? ""
                                  : "${setting['buy']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontSize: screenHeight * 0.025),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setting['available_unit'] == "0"
                                ? Container()
                                : Text(
                                    "Available quantity ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.015,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: FitnessAppTheme.fontName,
                                    ),
                                  ),
                            Text(
                              setting['available_unit'] == "0"
                                  ? "Sold Out"
                                  : "${setting['available_unit']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.015,
                                fontFamily: FitnessAppTheme.fontName,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    sellDialog();
                                  },
                                  child: Container(
                                    height: 35,
                                    width: screenWidth * 0.15,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: LightColors.kRed.withOpacity(1),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Text(
                                      "Sell",
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.025,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: FitnessAppTheme.fontName,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  " RM ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontSize: screenHeight * 0.025),
                                ),
                                Text(
                                  setting['sell'].toString().isEmpty
                                      ? ""
                                      : "${setting['sell']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontSize: screenHeight * 0.025),
                                ),
                              ],
                            ),
                            Text(
                              "Available quantity ${setting['available_unit']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * 0.015,
                                fontStyle: FontStyle.italic,
                                fontFamily: FitnessAppTheme.fontName,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  actions: [
                    widget.customer.isEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.login_outlined,
                              color: Colors.white,
                              size: screenHeight * 0.03,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen(),
                                ),
                              );
                            })
                        : IconButton(
                            icon: Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                              size: screenHeight * 0.03,
                            ),
                            onPressed: () {
                              util.logout(context);
                            })
                  ],
                ),
                SliverAppBar(
                  pinned: false,
                  snap: true,
                  floating: true,
                  centerTitle: false,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.white,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                      titlePadding:
                          EdgeInsets.only(top: 20, left: 17.5, bottom: 10),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                "Trading History",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: screenHeight * 0.02,
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: FitnessAppTheme.darkerText,
                                ),
                              )),
                          widget.customer.isEmpty
                              ? Container()
                              : IconButton(
                                  icon: Icon(
                                    Icons.refresh,
                                    color: LightColors.kDarkBlue,
                                    size: screenHeight * 0.03,
                                  ),
                                  onPressed: () {
                                    clearFile();
                                    util.dialog(
                                        context, "Refreshing, please wait...");
                                    loadHistory();
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      util.pop(context);
                                    });
                                  })
                        ],
                      )),
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                history.isEmpty
                    ? SliverAppBar(
                        pinned: true,
                        snap: true,
                        floating: true,
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.white,
                        automaticallyImplyLeading: false,
                        collapsedHeight: 200,
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.customer.isEmpty
                                      ? "Please login to see trade history."
                                      : "No trade history yet.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FitnessAppTheme.fontName,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                widget.customer.isEmpty
                                    ? Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          LoginScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 60,
                                              width: screenWidth / 2.5,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: LightColors.kDarkBlue
                                                    .withOpacity(1),
                                              ),
                                              child: Text(
                                                "Login",
                                                style: TextStyle(
                                                  fontSize: screenHeight * 0.03,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Dimension.defaultSize,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          RegisterScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 60,
                                              width: screenWidth / 2.5,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: LightColors.kDarkBlue
                                                    .withOpacity(1),
                                              ),
                                              child: Text(
                                                "Register",
                                                style: TextStyle(
                                                  fontSize: screenHeight * 0.03,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            )),
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: history.length, (context, i) {
                        Utility util = Utility();

                        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
                            .parse(history[i]['created_at']);
                        var inputDate = DateTime.parse(parseDate.toString());
                        var outputFormat = DateFormat('MMM dd, HH:mm');
                        var created_at = outputFormat.format(inputDate);

                        DateTime parseDate2 = DateFormat("yyyy-MM-dd HH:mm:ss")
                            .parse(history[i]['expired_at']);
                        var inputDate2 = DateTime.parse(parseDate2.toString());
                        var outputFormat2 = DateFormat('MMM dd, HH:mm:ss');
                        var expired_at = outputFormat2.format(inputDate2);

                        String rate = history[i]['rate'];

                        DateTime now = DateTime.now();
                        DateTime due = DateTime.parse(history[i]['expired_at']);

                        bool showCountDown = false;
                        if (history[i]['status'] == "1") {
                          showCountDown = true;
                        }

                        var totalAmount = history[i]['total'].toString();
                        var totalLen = history[i]['total'].toString().length;
                        if (totalLen == 6) {
                          totalAmount = totalAmount + '0';
                        }

                        return Container(
                            padding: EdgeInsets.all(7.5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showItems[i] = !showItems[i];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            color: LightColors.kDarkBlue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: history[i][
                                                                      'buy_sell'] ==
                                                                  "Buy"
                                                              ? LightColors
                                                                  .kDarkGreen
                                                              : LightColors
                                                                  .kRed,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Icon(
                                                          history[i]['buy_sell'] ==
                                                                  "Buy"
                                                              ? Icons
                                                                  .arrow_downward
                                                              : Icons
                                                                  .arrow_outward,
                                                          color: Colors.white,
                                                          size: screenHeight *
                                                              0.037,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenHeight * 0.02,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            history[i]['status'] ==
                                                                    "1"
                                                                ? "Pending"
                                                                : history[i][
                                                                            'status'] ==
                                                                        "2"
                                                                    ? "Rejected"
                                                                    : "Completed",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    screenHeight *
                                                                        0.022,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            created_at,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize:
                                                                    screenHeight *
                                                                        0.017,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        (history[i]['buy_sell'] ==
                                                                    "Buy"
                                                                ? "+"
                                                                : "-") +
                                                            totalAmount,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                screenHeight *
                                                                    0.022,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${history[i]['rate']} x ${history[i]['unit']} units",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                screenHeight *
                                                                    0.017,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                            Visibility(
                                                visible: showItems[i],
                                                child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 15, 0, 0),
                                                    padding: EdgeInsets.all(5),
                                                    width: screenWidth,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Table(
                                                          columnWidths: {
                                                            0: FlexColumnWidth(
                                                                1.5),
                                                            1: FlexColumnWidth(
                                                                8.5),
                                                          },
                                                          defaultVerticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          children: [
                                                            TableRow(children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Icon(
                                                                  history[i]['buy_sell'] ==
                                                                          "Buy"
                                                                      ? Icons
                                                                          .account_balance_wallet
                                                                      : Icons
                                                                          .credit_card,
                                                                  size:
                                                                      screenHeight *
                                                                          0.03,
                                                                  color: LightColors
                                                                      .kDarkBlue,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: history[i]
                                                                            [
                                                                            'buy_sell'] ==
                                                                        "Buy"
                                                                    ? Text(
                                                                        "${history[i]['customer_wallet']}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.0),
                                                                      )
                                                                    : Text(
                                                                        "${history[i]['bank_name']}\n${history[i]['bank_acc']}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15.0),
                                                                      ),
                                                              ),
                                                            ]),
                                                            TableRow(children: [
                                                              Divider(
                                                                color: LightColors
                                                                    .kDarkBlue,
                                                              ),
                                                              Divider(
                                                                color: LightColors
                                                                    .kDarkBlue,
                                                              )
                                                            ]),
                                                            TableRow(children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Icon(
                                                                  history[i]['buy_sell'] ==
                                                                          "Buy"
                                                                      ? Icons
                                                                          .credit_card
                                                                      : Icons
                                                                          .account_balance_wallet,
                                                                  size:
                                                                      screenHeight *
                                                                          0.03,
                                                                  color: LightColors
                                                                      .kDarkBlue,
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: history[i]['buy_sell'] ==
                                                                                "Buy"
                                                                            ? Text(
                                                                                "${history[i]['admin_bank_name']}\n${history[i]['admin_bank_acc']}",
                                                                                style: TextStyle(fontSize: 15.0),
                                                                              )
                                                                            : Text(
                                                                                "${history[i]['admin_wallet']}",
                                                                                style: TextStyle(fontSize: 15.0),
                                                                              ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      ElevatedButton(
                                                                        child: Icon(
                                                                            Icons
                                                                                .copy,
                                                                            color:
                                                                                Colors.white,
                                                                            size: 18),
                                                                        style: ButtonStyle(
                                                                            fixedSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                            backgroundColor: MaterialStateProperty.all<Color>(LightColors.kDarkBlue),
                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ))),
                                                                        onPressed:
                                                                            () async {
                                                                          await Clipboard.setData(
                                                                              ClipboardData(text: history[i]['buy_sell'] == "Buy" ? history[i]['admin_bank_acc'] : history[i]['admin_wallet']));
                                                                          history[i]['buy_sell'] == "Buy"
                                                                              ? util.toast("Copied admin bank account number to the clipboard.")
                                                                              : util.toast("Copied admin wallet address to the clipboard.");
                                                                        },
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ]),
                                                            showCountDown
                                                                ? TableRow(
                                                                    children: [
                                                                        Divider(
                                                                          color:
                                                                              LightColors.kDarkBlue,
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              LightColors.kDarkBlue,
                                                                        )
                                                                      ])
                                                                : TableRow(
                                                                    children: [
                                                                        Container(),
                                                                        Container()
                                                                      ]),
                                                            showCountDown
                                                                ? TableRow(
                                                                    children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(5),
                                                                          child:
                                                                              Icon(
                                                                            Icons.access_time_rounded,
                                                                            size:
                                                                                screenHeight * 0.03,
                                                                            color:
                                                                                LightColors.kDarkBlue,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.all(5),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Submit attachment before $expired_at\n",
                                                                                  style: TextStyle(fontSize: 15.0),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Time left: ",
                                                                                      style: TextStyle(fontSize: 15.0),
                                                                                    ),
                                                                                    CountDownText(
                                                                                      due: due,
                                                                                      finishedText: "EXPIRED",
                                                                                      showLabel: true,
                                                                                      longDateName: false,
                                                                                      style: TextStyle(fontSize: 15.0),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            )),
                                                                      ])
                                                                : TableRow(
                                                                    children: [
                                                                        Container(),
                                                                        Container()
                                                                      ]),
                                                            TableRow(children: [
                                                              Divider(
                                                                color: LightColors
                                                                    .kDarkBlue,
                                                              ),
                                                              Divider(
                                                                color: LightColors
                                                                    .kDarkBlue,
                                                              )
                                                            ]),
                                                            TableRow(children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Icon(
                                                                  Icons
                                                                      .picture_as_pdf,
                                                                  size:
                                                                      screenHeight *
                                                                          0.03,
                                                                  color: LightColors
                                                                      .kDarkBlue,
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                              "You"),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          history[i]['status'] == "2"
                                                                              ? Text("-")
                                                                              : history[i]['customer_attachment'] != null
                                                                                  ? GestureDetector(
                                                                                      child: Icon(
                                                                                      Icons.download,
                                                                                      color: LightColors.kDarkBlue,
                                                                                      size: screenHeight * 0.03,
                                                                                    ))
                                                                                  : attachmentNames.isEmpty
                                                                                      ? Container()
                                                                                      : Column(
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              child: GestureDetector(
                                                                                                  onLongPress: () async {
                                                                                                    var remove = await util.confirmationDialog(context, "Remove chosen attachment?");

                                                                                                    if (remove) {
                                                                                                      setState(() {
                                                                                                        attachmentFiles.clear();
                                                                                                        attachmentExt.clear();
                                                                                                        attachmentNames.clear();
                                                                                                      });

                                                                                                      util.toast("Attachment cleared.");
                                                                                                    }
                                                                                                  },
                                                                                                  child: Icon(
                                                                                                    Icons.upload_file,
                                                                                                    color: LightColors.kDarkBlue,
                                                                                                    size: screenHeight * 0.03,
                                                                                                  )),
                                                                                            ),
                                                                                            ElevatedButton(
                                                                                                child: Icon(Icons.file_upload, color: Colors.white, size: 18),
                                                                                                style: ButtonStyle(
                                                                                                    fixedSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                                                                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                                    backgroundColor: MaterialStateProperty.all<Color>(LightColors.kDarkBlue),
                                                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ))),
                                                                                                onPressed: () async {
                                                                                                  if (await util.confirmationDialog(context, "Confirm upload attachment?")) {
                                                                                                    if (due.isAfter(now)) {
                                                                                                      EasyLoading.show();
                                                                                                      // api call for upload server
                                                                                                      dynamic fileUpload;
                                                                                                      if (pickfile != null) {
                                                                                                        fileUpload = await MultipartFile.fromFile(
                                                                                                          pickfile!,
                                                                                                        );
                                                                                                      }
                                                                                                      dynamic fileUploadCamera;
                                                                                                      if (pickfileCamera != null) {
                                                                                                        fileUploadCamera = await MultipartFile.fromFile(
                                                                                                          pickfileCamera!,
                                                                                                        );
                                                                                                      }
                                                                                                      FormData formData = FormData.fromMap({
                                                                                                        'id': history[i]['id'],
                                                                                                        'image_upload': fileUploadCamera,
                                                                                                        'file_upload': fileUpload,
                                                                                                      });
                                                                                                      Response response = await Dio().post(
                                                                                                        '${util.baseUrl()}file_upload.php',
                                                                                                        data: formData,
                                                                                                        options: Options(
                                                                                                          contentType: 'multipart/form-data',
                                                                                                        ),
                                                                                                      );
                                                                                                      // end
                                                                                                      EasyLoading.dismiss();
                                                                                                      uploadAttachment(history[i]['id']);
                                                                                                    } else {
                                                                                                      util.toast("Unable to upload attachment. Reason: This trade has already expired.");
                                                                                                    }
                                                                                                  }
                                                                                                }),
                                                                                          ],
                                                                                        ),
                                                                          history[i]['customer_attachment'] != null || history[i]['status'] == "2"
                                                                              ? Container()
                                                                              : Column(
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                        child: Icon(Icons.add_a_photo, color: Colors.white, size: 18),
                                                                                        style: ButtonStyle(
                                                                                            fixedSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                                                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                            backgroundColor: MaterialStateProperty.all<Color>(LightColors.kDarkGreen),
                                                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                            ))),
                                                                                        onPressed: () async {
                                                                                          XFile? image = await ImagePicker().pickImage(
                                                                                            source: ImageSource.camera,
                                                                                            imageQuality: 30,
                                                                                          );

                                                                                          File result = File(image!.path);
                                                                                          pickfileCamera = image.path;
                                                                                          setState(() {});
                                                                                          clearFile();

                                                                                          attachmentFiles.add(result);

                                                                                          for (var i = 0; i < attachmentFiles.length; i++) {
                                                                                            String file_name = path.basename(attachmentFiles[i].path);
                                                                                            String file_ext = path.extension(attachmentFiles[i].path);

                                                                                            setState(() {
                                                                                              attachmentNames.add("${i + 1}. $file_name");
                                                                                              attachmentExt.add(file_ext);
                                                                                            });
                                                                                          }
                                                                                        }),
                                                                                    ElevatedButton(
                                                                                      child: Icon(Icons.file_open, color: Colors.white, size: 18),
                                                                                      style: ButtonStyle(
                                                                                          fixedSize: MaterialStateProperty.all<Size>(Size(40, 40)),
                                                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                                          backgroundColor: MaterialStateProperty.all<Color>(LightColors.kDarkGreen),
                                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ))),
                                                                                      onPressed: () async {
                                                                                        // ignore: unused_local_variable
                                                                                        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
                                                                                        if (result != null) {
                                                                                          PlatformFile file = result.files.first;
                                                                                          pickfile = file.path.toString();
                                                                                          setState(() {});

                                                                                          List<File> temp = result.paths.map((path) => File(path!)).toList();

                                                                                          clearFile();

                                                                                          for (var j = 0; j < temp.length; j++) {
                                                                                            attachmentFiles.add(temp[j]);
                                                                                          }

                                                                                          for (var i = 0; i < attachmentFiles.length; i++) {
                                                                                            String file_name = path.basename(attachmentFiles[i].path);
                                                                                            String file_ext = path.extension(attachmentFiles[i].path);

                                                                                            setState(() {
                                                                                              attachmentNames.add("${i + 1}. $file_name");
                                                                                              attachmentExt.add(file_ext);
                                                                                            });
                                                                                          }
                                                                                        } else {
                                                                                          // User canceled the picker
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Text(
                                                                              "Admin"),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          history[i]['status'] == "2"
                                                                              ? Text("-")
                                                                              : history[i]['admin_attachment'] == null
                                                                                  ? Text("Waiting Admin...")
                                                                                  : GestureDetector(
                                                                                      child: Icon(
                                                                                      Icons.download,
                                                                                      color: LightColors.kDarkBlue,
                                                                                      size: screenHeight * 0.03,
                                                                                    )),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )

                                                                  //onTap: () => util.displaySinglePicture(context, 2, items[j]['photo']),
                                                                  ),
                                                            ]),
                                                          ],
                                                        )
                                                      ],
                                                    )))
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ));
                      })),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: screenHeight * 0.1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      buyDialog();
                    },
                    child: Container(
                      height: screenHeight * 0.06,
                      width: screenWidth / 2.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: LightColors.kDarkGreen),
                      child: Text(
                        "Buy",
                        style: TextStyle(
                          fontSize: screenHeight * 0.03,
                          color: Colors.white,
                          fontFamily: FitnessAppTheme.fontName,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sellDialog();
                    },
                    child: Container(
                      height: screenHeight * 0.06,
                      width: screenWidth / 2.5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: LightColors.kRed),
                      child: Text(
                        "Sell",
                        style: TextStyle(
                          fontSize: screenHeight * 0.03,
                          color: Colors.white,
                          fontFamily: FitnessAppTheme.fontName,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }

  void loadSetting() {
    String url = "${util.baseUrl()}setting.php";

    http.post(Uri.parse(url), body: {
      "operation": "load setting",
    }).then((res) {
      if (util.isMap(res.body)) {
        Map data = jsonDecode(res.body);
        String prev_buy = setting.isEmpty ? "0" : setting['buy'];
        String prev_sell = setting.isEmpty ? "0" : setting['sell'];
        String prev_unit = setting.isEmpty ? "0" : setting['available_unit'];

        setState(() {
          setting = data['setting'];

          if (prev_buy != setting['buy']) {
            total_buy_tec.text =
                util.getTotalString(setting['buy'], unit_buy_tec.text);
          }

          if (prev_unit != setting['available_unit'] &&
              int.parse(unit_buy_tec.text) >
                  int.parse(setting['available_unit'])) {
            unit_buy_tec.text = setting['available_unit'];
            total_buy_tec.text =
                util.getTotalString(setting['buy'], unit_buy_tec.text);
          }

          if (prev_sell != setting['sell']) {
            total_sell_tec.text =
                util.getTotalString(setting['sell'], unit_sell_tec.text);
          }
        });
      } else {
        util.toast("Failed to refresh data");
      }
    });
  }

  void loadHistory() {
    if (widget.customer.isNotEmpty) {
      clearFile();
      setState(() {
        history.clear();
        showItems.clear();
      });

      String url = "${util.baseUrl()}setting.php";

      http.post(Uri.parse(url), body: {
        "operation": "load history",
        "user_id": widget.customer['id']
      }).then((res) {
        if (util.isMap(res.body)) {
          Map data = jsonDecode(res.body);
          setState(() {
            history = data['history'];
          });

          for (int i = 0; i < history.length; i++) {
            showItems.add(false);
            //attachmentFiles.add(File(""));
          }
        } else {
          util.toast("Failed to load history");
        }
      });
    }
  }

  void clearFile() {
    attachmentExt.clear();
    attachmentFiles.clear();
    attachmentNames.clear();
  }

  void uploadAttachment(order_id) {
    util.toast("File uploaded successfully. (DEMO)");
    clearFile();
    loadHistory();
    /*
    if (widget.customer.isNotEmpty) {
      setState(() {
        history.clear();
      });
      
      String url = "${util.baseUrl()}setting.php";

      http.post(Uri.parse(url), body: {
        "operation": "load history",
        "user_id": widget.customer['id']
      }).then((res) {
        if (util.isMap(res.body)) {
          Map data = jsonDecode(res.body);
          setState(() {
            history = data['history'];
          });
        } else {
          util.toast("Failed to load history");
        }
      });
    }
    */
  }

  void buyDialog() {
    setState(() {
      unit_buy_tec.text = "1";
      wallet_tec.text = "";
      total_buy_tec.text =
          util.getTotalString(setting['buy'], unit_buy_tec.text);
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Buy Tether USDT (TRC20)",
                  style: TextStyle(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                      color: LightColors.kDarkGreen)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: total_buy_tec,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: LightColors.kDarkBlue),
                      cursorColor: LightColors.kDarkGreen,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: 'Total (RM)',
                        enabled: false,
                        labelStyle: TextStyle(color: LightColors.kDarkGreen),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kDarkGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: unit_buy_tec,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: LightColors.kDarkBlue),
                      cursorColor: LightColors.kDarkGreen,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: 'Unit *',
                        labelStyle: TextStyle(color: LightColors.kDarkGreen),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kDarkGreen,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kDarkGreen,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          total_buy_tec.text = util.getTotalString(
                              setting['buy'], unit_buy_tec.text);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: Dimension.defaultSize,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      maxLines: 3,
                      controller: wallet_tec,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: LightColors.kDarkBlue),
                      keyboardType: TextInputType.text,
                      cursorColor: LightColors.kDarkGreen,
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        labelText: 'Your Wallet Address. *',
                        labelStyle: TextStyle(color: LightColors.kDarkGreen),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kDarkGreen,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kDarkGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (widget.customer.isEmpty) {
                      util.toast("Kindly login to buy.");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    } else {
                      if (unit_buy_tec.text.isEmpty ||
                          unit_buy_tec.text == "0" ||
                          wallet_tec.text.isEmpty) {
                        util.toast(
                            "Please fill in the required fields before proceed.");
                      } else {
                        if (await util.confirmationDialog(context,
                            "Confirm buying ? \n\nRM ${total_buy_tec.text}")) {
                          String url = "${util.baseUrl()}order.php";
                          http.post(Uri.parse(url), body: {
                            "operation": "buy crypto",
                            "customer_id": widget.customer['id'],
                            "customer_name": widget.customer['name'],
                            "unit": unit_buy_tec.text,
                            "wallet": wallet_tec.text,
                            "rate": setting['buy'],
                          }).then((res) {
                            Map response = jsonDecode(res.body);
                            if (response['status'] == "success") {
                              util.toast(
                                  "Successfully submitted a buying request.");
                              util.pop(context);

                              //util.infoDialog(context, "dasd");

                              clearFile();
                              loadHistory();
                            } else {
                              util.toast("Failed to submit a buying request.");
                            }
                          });
                        }
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    elevation: 5,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: LightColors.kDarkGreen,
                  ),
                  child: Text("Buy",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
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
                  child: Text("Cancel",
                      style: TextStyle(
                          color: LightColors.kDarkGreen,
                          fontSize: screenHeight * 0.025,
                          fontFamily: 'Poppins')),
                ),
              ],
            );
          });
        });
  }

  void sellDialog() {
    setState(() {
      unit_sell_tec.text = "1";
      bank_tec = "";
      acc_tec.clear();

      total_sell_tec.text =
          util.getTotalString(setting['sell'], unit_sell_tec.text);
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Sell Tether USDT (TRC20)",
                  style: TextStyle(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.bold,
                      color: LightColors.kRed)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: total_sell_tec,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: LightColors.kDarkBlue),
                      cursorColor: LightColors.kRed,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: 'Total (RM)',
                        enabled: false,
                        labelStyle: TextStyle(color: LightColors.kRed),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 3,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: unit_sell_tec,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: LightColors.kDarkBlue),
                      cursorColor: LightColors.kRed,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        labelText: 'Unit *',
                        labelStyle: TextStyle(color: LightColors.kRed),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          total_sell_tec.text = util.getTotalString(
                              setting['sell'], unit_sell_tec.text);
                        });
                      },
                    ),
                  ),
                  DropdownTitle(title: "Bank *"),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),
                    child: DropdownButtonFormField(
                      value: bank_tec,
                      dropdownColor: Colors.white,
                      hint: const Text("Please Select",
                          style: TextStyle(color: LightColors.kRed)),
                      isDense: false,
                      itemHeight: 50,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'Your Bank Name *',
                        border: InputBorder.none,
                        labelStyle: TextStyle(color: LightColors.kRed),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                      ),
                      items: banks
                          .map((item) => DropdownMenuItem<String>(
                                value: item['value'],
                                child: Text(
                                  item['parameter'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          bank_tec = value!;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: Dimension.defaultSize,
                    ),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: acc_tec,
                      style: TextStyle(
                          fontSize: screenHeight * 0.02,
                          color: LightColors.kDarkBlue),
                      keyboardType: TextInputType.text,
                      cursorColor: LightColors.kRed,
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        labelText: 'Your Bank Acc No. *',
                        labelStyle: TextStyle(color: LightColors.kRed),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            width: 1,
                            color: LightColors.kRed,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (widget.customer.isEmpty) {
                      util.toast("Kindly login to sell.");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    } else {
                      if (unit_sell_tec.text.isEmpty ||
                          unit_sell_tec.text == "0" ||
                          acc_tec.text.isEmpty ||
                          bank_tec == "") {
                        util.toast(
                            "Please fill in the required fields before proceed.");
                      } else {
                        if (await util.confirmationDialog(context,
                            "Confirm selling ? \n\nRM ${total_sell_tec.text}")) {
                          String url = "${util.baseUrl()}order.php";

                          http.post(Uri.parse(url), body: {
                            "operation": "sell crypto",
                            "customer_id": widget.customer['id'],
                            "customer_name": widget.customer['name'],
                            "unit": unit_sell_tec.text,
                            "bank_name": bank_tec,
                            "bank_acc": acc_tec.text,
                            "rate": setting['sell'],
                          }).then((res) {
                            Map response = jsonDecode(res.body);

                            if (response['status'] == "success") {
                              util.toast(
                                  "Successfully submitted a selling request.");
                              util.pop(context);

                              clearFile();
                              loadHistory();
                            } else {
                              util.toast("Failed to submit a selling request.");
                            }
                          });
                        }
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    elevation: 5,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: LightColors.kRed,
                  ),
                  child: Text("Sell",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.025,
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
                  child: Text("Cancel",
                      style: TextStyle(
                          color: LightColors.kRed,
                          fontSize: screenHeight * 0.025,
                          fontFamily: 'Poppins')),
                ),
              ],
            );
          });
        });
  }
}
