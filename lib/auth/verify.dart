import 'dart:convert';

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

class VerifyScreen extends StatefulWidget {
  final String email;
  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // form
  final formKeyVerify = GlobalKey<FormState>();
  TextEditingController verifyController = TextEditingController();

  @override
  void dispose() {
    verifyController.dispose();
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
                'Verify Your Email',
                style: TextStyle(
                  fontSize: Dimension.defaultSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Dimension.defaultSize),
              Form(
                key: formKeyVerify,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: verifyController,
                      keyboardType: TextInputType.number,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'This field is required'),
                      ]),
                      decoration: FormsUtils.inputStyle(
                        hintText: 'Enter valid code',
                      ),
                    ),
                    const SizedBox(height: Dimension.defaultSize),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final form = formKeyVerify.currentState;
                        if (form!.validate()) {
                          EasyLoading.show(status: 'loading...');
                          form.save();
                          // call api part
                          FormData formData = FormData.fromMap({
                            'code': verifyController.text,
                            'email': widget.email,
                          });
                          try {
                            Response response = await Dio().post(
                              '${Utility().baseUrl()}verify.php',
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        NewPasswordScreen(email: widget.email),
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
