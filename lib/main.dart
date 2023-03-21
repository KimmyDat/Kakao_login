import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_login/home_screen.dart';

void main() {
  KakaoSdk.init(
      nativeAppKey: 'c0f42e8cc31873acfdac4f51bcf8b61d',
      javaScriptAppKey: '157adb9ddcfe7bef60f5d52c24a28017');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: KakaoLogin(),
    );
  }
}

class KakaoLogin extends StatefulWidget {
  const KakaoLogin({Key? key}) : super(key: key);

  @override
  State<KakaoLogin> createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;

  @override
  void initState() {
    _initKakaoTalkInstalled();
    super.initState();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode: authCode);
      TokenManagerProvider.instance.manager.setToken(token);
      print(token);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.authorize();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.authorizeWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('kakao login test'),
      ),
      body: Center(
        child: InkWell(
          onTap: () =>
              _isKakaoTalkInstalled ? _loginWithTalk() : _loginWithKakao(),
          child: Container(
            width: size.width * 0.6,
            height: size.height * 0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.yellow),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '카카오계정 로그인',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
