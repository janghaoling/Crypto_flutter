// ignore_for_file: prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables, deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:crypto/auth/verify.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/forms_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../home.dart';
import '../partials/light_colors.dart';
import '../partials/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;
  Utility util = Utility();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController controller;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  var _scaffoldKey;
  bool hidePass = true;

  // form
  final _formKeyForgotPass = GlobalKey<FormState>();
  TextEditingController forEmailController = TextEditingController();

  @override
  void initState() {
    // _emailController.text = "abc123@abc.com";
    // _passwordController.text = "12345678";
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    forEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Stack(
          alignment: Alignment(0, -0.5),
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.fill)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment(0, 1),
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight * 0.30,
                            width: screenWidth * 0.70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                opacity: 1,
                                image: AssetImage("assets/images/logo.png"),
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(1),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          LightColors.kDarkBlue.withOpacity(1),
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: LightColors.kDarkBlue
                                                .withOpacity(1),
                                            fontFamily: 'Poppins'),
                                        icon: Icon(
                                          Icons.email_outlined,
                                          size: 22,
                                          color: LightColors.kDarkBlue
                                              .withOpacity(1),
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(1),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: _passwordController,
                                              textInputAction:
                                                  TextInputAction.done,
                                              obscureText: hidePass,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: LightColors.kDarkBlue
                                                    .withOpacity(1),
                                              ),
                                              decoration: InputDecoration(
                                                  hintText: "Password",
                                                  hintStyle: TextStyle(
                                                      fontSize: 16,
                                                      color: LightColors
                                                          .kDarkBlue
                                                          .withOpacity(1),
                                                      fontFamily: 'Poppins'),
                                                  icon: Icon(
                                                    Icons.lock_outline,
                                                    size: 22,
                                                    color: LightColors.kDarkBlue
                                                        .withOpacity(1),
                                                  ),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none),
                                            )),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                hidePass = !hidePass;
                                              });
                                            },
                                            child: Icon(
                                              hidePass
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: LightColors.kDarkBlue
                                                  .withOpacity(1),
                                              size: 22,
                                            ))
                                      ]),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.only(left: 23),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(1),
                                                    border: Border.all(
                                                      width: 0.75,
                                                      color: LightColors
                                                          .kDarkBlue
                                                          .withOpacity(1),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                child: Transform.scale(
                                                    scale: 1.15,
                                                    child: Theme(
                                                      data: ThemeData(
                                                        unselectedWidgetColor:
                                                            LightColors
                                                                .kDarkBlue
                                                                .withOpacity(1),
                                                      ),
                                                      child: Checkbox(
                                                        value: rememberMe,
                                                        activeColor:
                                                            Colors.white,
                                                        checkColor: LightColors
                                                            .kDarkBlue
                                                            .withOpacity(1),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            rememberMe = value!;
                                                          });
                                                        },
                                                      ),
                                                    ))),
                                            SizedBox(width: 10),
                                            Text("Remember me",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily: 'Poppins',
                                                    color: LightColors.kDarkBlue
                                                        .withOpacity(1))),
                                          ],
                                        ),
                                      ]),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _loginUser();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: LightColors.kDarkBlue
                                              .withOpacity(1),
                                          side: BorderSide(
                                            width: 1,
                                            color: Colors.white.withOpacity(1),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              20, 20, 20, 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'LOGIN',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Forgot password? ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black)),
                                        GestureDetector(
                                          child: Text("Recover here",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                          onTap: () {
                                            forgotPasswordView(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginUser() {
    String _email = _emailController.text;
    String _password = _passwordController.text;
    String loginUrl = "${util.baseUrl()}profile.php";

    if (_email.isEmpty || _password.isEmpty) {
      util.toast("Email and Password cannot be empty!");
    } else {
      util.dialog(context, "Logging in ...");

      http.post(Uri.parse(loginUrl), body: {
        "operation": "login",
        "email": _email,
        "password": _password,
      }).then((res) async {
        util.pop(context);
        if (util.isMap(res.body)) {
          Map customer = jsonDecode(res.body)['customer'][0];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('customer_id', customer['id'].toString());
          savePreference(rememberMe);
          util.toast("${"Hello " + customer['name']} !");
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    MainScreen(customer: customer),
              ),
            );
          }
        } else {
          util.toast(res.body);
        }
      }).catchError((error) {
        util.pop(context);
        print("Error occured when trying to login: $error");
        util.toast("Error occured when trying to login: $error");
      });
    }
  }

  void savePreference(bool save) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (save == true) {
      //save preference
      await prefs.setString("email", "");
      await prefs.setString('email', email);
      await prefs.setString("password", "");
      await prefs.setString('password', password);
    } else {
      await prefs.setString("email", "");
      await prefs.setString("password", "");
    }
  }

  void forgotPasswordView(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: RGB.whiteColor,
        enableDrag: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              Dimension.defaultSize,
            ),
            topRight: Radius.circular(
              Dimension.defaultSize,
            ),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimension.defaultSize),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Dimension.defaultSize / 2),
                  Text('Forgot password?'),
                  const SizedBox(height: Dimension.defaultSize),
                  Form(
                    key: _formKeyForgotPass,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: forEmailController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'This field is required'),
                            EmailValidator(
                                errorText: 'Enter a valid email address')
                          ]),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Enter valid email',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final form = _formKeyForgotPass.currentState;
                            if (form!.validate()) {
                              EasyLoading.show(status: 'loading...');
                              form.save();
                              // call api part
                              FormData formData = FormData.fromMap({
                                'email': forEmailController.text,
                              });
                              try {
                                Response response = await Dio().post(
                                  '${Utility().baseUrl()}forget_password.php',
                                  data: formData,
                                  options: Options(
                                    contentType: 'multipart/form-data',
                                  ),
                                );
                                Map userData = jsonDecode(response.data);
                                EasyLoading.dismiss();
                                if (userData['error']) {
                                  Fluttertoast.showToast(
                                      msg: userData['message']);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: userData['message']);
                                  if (mounted) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VerifyScreen(
                                          email: forEmailController.text,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: e.toString(),
                                );
                              }
                            }
                            return;
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                LightColors.kDarkBlue.withOpacity(1),
                            side: BorderSide(
                              width: 1,
                              color: Colors.white.withOpacity(1),
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
