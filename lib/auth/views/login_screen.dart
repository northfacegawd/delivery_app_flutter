import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/auth/constants/data.dart';
import 'package:delivery_app/common/components/custom_text_form_field.dart';
import 'package:delivery_app/common/constants/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/common/views/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final dio = Dio();
  final emulatorIp = '10.0.2.2:3000';
  final simulatorIP = '127.0.0.1:3000';
  final _formKey = GlobalKey<FormBuilderState>();

  Future _onSubmit() async {
    final ip = Platform.isIOS ? simulatorIP : emulatorIp;
    if (_formKey.currentState != null &&
        _formKey.currentState!.saveAndValidate()) {
      final email = _formKey.currentState!.value["email"];
      final password = _formKey.currentState!.value["password"];
      // ID:비밀번호
      final rawString = '$email:$password';
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      final token = stringToBase64.encode(rawString);
      final res = await dio.post(
        "http://$ip/auth/login",
        options: Options(headers: {
          'Authorization': "Basic $token",
        }),
      );
      await Future.wait([
        storage.write(key: REFRESH_TOKEN_KEY, value: res.data['refreshToken']),
        storage.write(key: ACCESS_TOKEN_KEY, value: res.data['accessToken']),
      ]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RootTap(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Title(),
                  const SizedBox(height: 16),
                  const _SubTitle(),
                  Image.asset(
                    'assets/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width / 3 * 2,
                  ),
                  CustomTextFormField(
                    name: "email",
                    initialValue: "test@codefactory.ai",
                    hinText: '이메일을 입력해주세요.',
                    autofocus: false,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: "이메일을 입력해주세요."),
                      FormBuilderValidators.email(
                          errorText: "이메일 형식에 맞게 입력해주세요."),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    name: "password",
                    initialValue: "testtest",
                    obscureText: true,
                    autofocus: false,
                    hinText: '비밀번호를 입력해주세요',
                    validator: FormBuilderValidators.required(
                      errorText: "패스워드를 입력해주세요.",
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: const Text("로그인"),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("회원가입"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "환경합니다!",
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)",
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
