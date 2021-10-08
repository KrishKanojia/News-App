import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constraints.dart';
import 'package:news_app/main.dart';
import 'package:news_app/screens/signup.dart';
import 'package:news_app/widgets/mytextformfield.dart';
import 'package:news_app/widgets/passwordtextformfield.dart';
import 'package:news_app/widgets/transitionwidget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

late double _height, _width;

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  RegExp regExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  bool obserText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void validation() async {
    if (email.text.isEmpty && password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Both Field Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else {
      final FormState? _form = _formKey.currentState;
      if (_form!.validate()) {
        String _email = email.text.trim();
        try {
          UserCredential User = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: _email, password: password.text);
          print("User Logged In" + User.user!.uid);

          print("Hello World");
          FocusScope.of(context).unfocus();
          email.clear();
          password.clear();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => WelcomeScreen(),
            ),
          );
          // showAlertDialog(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
            ),
          );
        }
      } else {
        print("No");
      }
    }
  }

  showAlertDialog(BuildContext ctx) {
    // set up the buttons

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Your are successfully logged in"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Positioned(
              width: _width,
              top: 0,
              child: Container(
                width: _width,
                height: _height * 0.4,
                decoration: BoxDecoration(
                    color: kprimary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )),
              ),
            ),
            Positioned(
              // width: _width,
              top: 70,
              left: _width * 0.25,
              right: _width * 0.25,
              child: Container(
                height: _height * 0.2,
                width: _width * 0.2,
                decoration: BoxDecoration(
                  // color: Colors.amber,
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/logo3.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: _width,
                      height: _height * 0.36,
                      decoration: BoxDecoration(
                        // color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: _height * 0.02),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              height: _height * 0.24,
                              // color: Colors.green,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyTextFormField(
                                    name: "Email",
                                    controller: email,
                                    myIcon: Icon(
                                      Icons.mail_outline,
                                      size: 18,
                                      color: kprimary,
                                    ),
                                  ),
                                  Container(
                                    height: _height * 0.11,
                                    // color: Colors.amber,
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PasswordTextFormField(
                                          name: "Password",
                                          controller: password,
                                          onTap: () {
                                            setState(() {
                                              obserText = !obserText;
                                            });
                                          },
                                          obscureText: obserText,
                                          myIcon: Icon(
                                            Icons.lock_outline_sharp,
                                            color: kprimary,
                                            size: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              "Forget Password?",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment(0, _height * 0.0014),
                            child: Container(
                              margin: EdgeInsets.only(top: _height * 0.05),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              height: _height * 0.12,
                              // color: Colors.green,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: _width * 0.55,
                                    height: _height * 0.06,
                                    // color: kprimary,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: StadiumBorder(),
                                          primary: kprimary),
                                      onPressed: () {
                                        validation();
                                      },
                                      child: Text("Sign In"),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: _width * 0.02,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: _height * 0.01,
                                    ),
                                    height: _height * 0.05,
                                    // color: Colors.amber,
                                    width: _width * 0.55,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Already have Account? ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              TansitionWidget(
                                                  widget: SignUp(),
                                                  alignment: Alignment.topLeft),
                                            );
                                          },
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              width: 70,
              left: 0,
              top: _width * 0.1,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      TansitionWidget(
                          widget: SignUp(), alignment: Alignment.topLeft),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
