// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:get/get.dart';
import 'package:getx_1/controllers/auth.controller.dart';
// import 'package:getx_1/services/cookie.services.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(name: 'email'),
              FormBuilderTextField(name: 'password'),
              ElevatedButton(
                  onPressed: () async {
                    // _formKey.currentState!.save();
                    final email = _formKey.currentState?.fields['email']!.value;
                    final password =
                        _formKey.currentState?.fields['password']!.value;
                    print(email);
                    print(password);
                    await AuthController()
                        .Login(context: context,email: email, password: password);
                    // print(password);
                    // Get.toNamed("/category");
                  },
                  child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
