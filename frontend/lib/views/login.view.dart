// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:getx_1/controllers/auth.controller.dart';
// import 'package:getx_1/services/cookie.services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: Image.asset(
                    "assets/images/twitter.png",
                    height: 119,
                    width: 142,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'email',
                      onChanged: (value) {
                        _formKey.currentState!.fields['email']?.validate();
                      },
                      validator: (Email) {
                        final RegExp email = RegExp(
                            r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]+)$');
                        if (!email.hasMatch(Email!)) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      onSaved: (Value) {
                        authController.email = Value;
                      },
                    ),
                    FormBuilderTextField(
                      name: 'password',
                      onChanged: (value) {
                        _formKey.currentState!.fields['password']?.validate();
                      },
                      validator: (Password) {
                        final RegExp password =
                            RegExp(r'(?:\d+[a-zA-Z]|[a-zA-Z]+\d)[a-zA-Z\d]*');
                        if (Password!.length >= 8 && Password.length <= 16) {
                          if (password.hasMatch(Password)) {
                            return null;
                          }
                        }
                        return 'Invalid Password';
                      },
                      onSaved: (Value) {
                        authController.password = Value;
                      },
                    ),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       // _formKey.currentState!.save();
                    //       // AuthController().email =
                    //       //     _formKey.currentState?.fields['email']!.value;
                    //       // AuthController().password =
                    //       //     _formKey.currentState?.fields['password']!.value;
                    //       // final email = _formKey.currentState?.fields['email']!.value;
                    //       // final password =
                    //       //     _formKey.currentState?.fields['password']!.value;
                    //       // print(email);
                    //       // print(password);

                    //     },
                    //     child: Text('Login'))
                  ],
                ),
              ),

              //const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.only(left: 258),
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "ลืมรหัสผ่าน",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ),
              //const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(0, 132, 143, 1)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          authController.Login();
                        }
                      },
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "คุณมีบัญชีแล้วหรือยัง ?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ))
                ],
              ),
              Text(
                  "------------------------------   หรือสมัครผ่าน   ------------------------------"),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 125,
                    height: 40,
                    child: SignInButton(
                      Buttons.Facebook,
                      text: "Facebook",
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 125,
                    height: 40,
                    child: SignInButton(
                      Buttons.Google,
                      text: "Google",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 125,
                height: 40,
                child: SignInButton(
                  Buttons.Twitter,
                  text: "Test",
                  onPressed: () {
                    // Get.to(() => Nologin());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
