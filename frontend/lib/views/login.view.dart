// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:getx_1/controllers/auth.controller.dart';
// import 'package:getx_1/services/cookie.services.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FormBuilder(
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
              ElevatedButton(
                  onPressed: () async {
                    // _formKey.currentState!.save();
                    // AuthController().email =
                    //     _formKey.currentState?.fields['email']!.value;
                    // AuthController().password =
                    //     _formKey.currentState?.fields['password']!.value;
                    // final email = _formKey.currentState?.fields['email']!.value;
                    // final password =
                    //     _formKey.currentState?.fields['password']!.value;
                    // print(email);
                    // print(password);

                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      authController.Login();
                    }
                  },
                  child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
