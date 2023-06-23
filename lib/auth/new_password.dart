import 'dart:convert';

import 'package:crypto/auth/login.dart';
import 'package:crypto/partials/light_colors.dart';
import 'package:crypto/partials/utility.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/forms_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  const NewPasswordScreen({super.key, required this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // form
  final formKeyNew = GlobalKey<FormState>();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  void dispose() {
    password1Controller.dispose();
    password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimension.defaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 76,
                  height: 76,
                ),
              ),
              const SizedBox(height: Dimension.defaultSize),
              const Text(
                'Setup your new password!',
                style: TextStyle(
                  fontSize: Dimension.defaultSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Dimension.defaultSize),
              Form(
                key: formKeyNew,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: password1Controller,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'This field is required'),
                      ]),
                      decoration: FormsUtils.inputStyle(
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(height: Dimension.defaultSize),
                    TextFormField(
                      controller: password2Controller,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'This field is required'),
                      ]),
                      decoration: FormsUtils.inputStyle(
                        hintText: 'Confirm Password',
                      ),
                    ),
                    const SizedBox(height: Dimension.defaultSize),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final form = formKeyNew.currentState;
                        if (form!.validate()) {
                          if (password1Controller.text ==
                              password2Controller.text) {
                            EasyLoading.show(status: 'loading...');
                            form.save();
                            // call api part
                            FormData formData = FormData.fromMap({
                              'password': password1Controller.text,
                              'email': widget.email,
                            });
                            try {
                              Response response = await Dio().post(
                                '${Utility().baseUrl()}new_password.php',
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const LoginScreen(),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: e.toString(),
                              );
                            }
                          } else {
                            Fluttertoast.showToast(msg: 'Password not match');
                          }
                        }
                        return;
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: LightColors.kDarkBlue.withOpacity(1),
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
      ),
    );
  }
}
