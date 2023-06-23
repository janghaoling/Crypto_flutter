import 'dart:convert';

import 'package:crypto/auth/otp.dart';
import 'package:crypto/partials/light_colors.dart';
import 'package:crypto/partials/utility.dart';
import 'package:crypto/utils/dimension_utils.dart';
import 'package:crypto/utils/forms_utils.dart';
import 'package:crypto/utils/rgb_utils.dart';
import 'package:crypto/utils/snackbar__utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // form
  final _formKeyCustomerAdd = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String? pickfile;

  String pictureLabel = 'Select IC Picture';

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    contactPersonController.dispose();
    emailController.dispose();
    passwordController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          alignment: const Alignment(0, -0.5),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ListView(
              children: [
                const SizedBox(height: Dimension.defaultSize),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: Dimension.defaultSize),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimension.defaultSize,
                  ),
                  child: Form(
                    key: _formKeyCustomerAdd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'This field is required'),
                          ]),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Name',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'This field is required'),
                          ]),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Address',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        TextFormField(
                          controller: contactPersonController,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'This field is required'),
                          ]),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Mobile Number',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'This field is required'),
                          ]),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'This field is required'),
                          ]),
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Password',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        GestureDetector(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: true,
                              allowedExtensions: ['jpg', 'png'],
                            );
                            if (result != null) {
                              PlatformFile file = result.files.first;
                              pickfile = file.path.toString();
                              pictureLabel = result.files.first.name.toString();
                              setState(() {});
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: Dimension.defaultSize,
                              horizontal: Dimension.defaultSize,
                            ),
                            decoration: BoxDecoration(
                              color: RGB.whiteColor,
                              border: Border.all(
                                width: 0.5,
                                color: RGB.borderColor.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimension.radiusSize,
                              ),
                            ),
                            child: Text(
                              pictureLabel,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        TextFormField(
                          controller: remarkController,
                          keyboardType: TextInputType.text,
                          decoration: FormsUtils.inputStyle(
                            hintText: 'Remark',
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                        ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final form = _formKeyCustomerAdd.currentState;
                            if (form!.validate()) {
                              EasyLoading.show(status: 'loading...');
                              form.save();
                              // call api part
                              // ignore: prefer_typing_uninitialized_variables
                              var multipartFile;
                              if (pickfile != null) {
                                multipartFile = await MultipartFile.fromFile(
                                  pickfile!,
                                );
                              }
                              FormData formData = FormData.fromMap({
                                'name': nameController.text,
                                'address': addressController.text,
                                'person_contact': contactPersonController.text,
                                'email': emailController.text,
                                'password': passwordController.text,
                                'ic_pictures': multipartFile,
                                'remarks': remarkController.text,
                              });
                              try {
                                Response response = await Dio().post(
                                  '${Utility().baseUrl()}register.php',
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
                                            OTPScreen(
                                          email: emailController.text,
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
                              'Register',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimension.defaultSize),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
