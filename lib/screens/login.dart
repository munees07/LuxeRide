import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luxeride/screens/bottom_nav.dart';
import 'package:luxeride/screens/splash.dart';
import 'package:luxeride/widgets/global_widgets.dart';

class Login extends StatefulWidget {
  const Login({super.key, this.username, this.password});

  final String? username;
  final String? password;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();

  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  void login() async {
    String username = usernamecontroller.text;
    String password = passwordcontroller.text;

    if (username == widget.username && password == widget.password) {
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(SplashScreenState.KEYLOGIN, true);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } else if (username == '' && password == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Details Not Entered'),
            content: const Text('Enter the Username and Password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incorrect Details'),
            content: const Text('Username or password is incorrect.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0x00f3f5f7),
          width: double.infinity,
          child: Form(
            key: _formkey,
            child: Column(children: [
              const Gap(60),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    'LUXE-RIDE',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 28),
                child: Text('RIDE YOUR DREAMS', style: TextStyle(fontSize: 33)),
              ),
              const MainImageWidget(imagepath: 'assets/images/ninjah2.png'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('LOGIN', style: TextStyle(fontSize: 25)),
                      const Gap(18),
                      SignupTextFormWidget(
                          hinttext: 'USERNAME',
                          controller: usernamecontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Username';
                            } else {
                              return null;
                            }
                          }),
                      const Gap(32),
                      SignupTextFormWidget(
                          hinttext: 'PASSWORD',
                          controller: passwordcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Password';
                            } else {
                              return null;
                            }
                          }),
                    ]),
              ),
              const Gap(54),
              FilledButtonWidget(
                  onPressedButton: () {
                    if (_formkey.currentState!.validate()) {
                      login();
                    }
                  },
                  buttontext: 'LOGIN')
            ]),
          ),
        ),
      ),
    );
  }
}
