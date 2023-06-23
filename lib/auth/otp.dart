import 'dart:convert';

import 'package:crypto/auth/login.dart';
import 'package:crypto/auth/new_password.dart';
import 'package:crypto/partials/light_colors.dart';
import 'package:crypto/partials/utility.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/forms_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // form
  final formKeyOTP = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
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
                'Please check your mobile sms for getting OTP',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Dimension.defaultSize),
              Form(
                key: formKeyOTP,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'This field is required'),
                      ]),
                      decoration: FormsUtils.inputStyle(
                        hintText: 'Enter valid OTP',
                      ),
                    ),
                    const SizedBox(height: Dimension.defaultSize),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final form = formKeyOTP.currentState;
                        if (form!.validate()) {
                          EasyLoading.show(status: 'loading...');
                          form.save();
                          // call api part
                          FormData formData = FormData.fromMap({
                            'otp': otpController.text,
                            'email': widget.email,
                          });
                          try {
                            Response response = await Dio().post(
                              '${Utility().baseUrl()}otp.php',
                              data: formData,
                              options: Options(
                                contentType: 'multipart/form-data',
                              ),
                            );
                            Map userData = jsonDecode(response.data);
                            EasyLoading.dismiss();
                            if (userData['error']) {
                              Fluttertoast.showToast(msg: userData['message']);
                            } else {
                              Fluttertoast.showToast(msg: userData['message']);
                              if (mounted) {
                                Navigator.pushReplacement(
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
