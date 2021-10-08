import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/main.dart';
import 'package:news_app/screens/signin.dart';
import 'package:news_app/widgets/mytextformfield.dart';
import 'package:news_app/widgets/passwordtextformfield.dart';
import 'package:news_app/widgets/transitionwidget.dart';

import '../constraints.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

late double _width, _height;

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RegExp regExp = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  bool obserText = true;

  bool isMale = true;

  void validation() async {
    if (userName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        address.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (userName.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6 letter "),
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
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
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 11 "),
        ),
      );
    } else if (address.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Address Is Empty"),
        ),
      );
    } else {
      try {
        UserCredential User = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text);
        FirebaseFirestore.instance.collection("User").doc(User.user!.uid).set({
          "UserName": userName.text,
          "UserId": User.user!.uid,
          "Email": email.text,
          "UserGender": isMale == true ? "Male" : "Female",
          "PhoneNumber": phoneNumber.text,
          "UserAddress": address.text,
          "UserImage": "",
        });
        showAlertDialog(context);
      } on PlatformException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  showAlertDialog(BuildContext ctx) {
    // set up the buttons

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Congrulations"),
      content: Text("Your Account has beeen created Successfully!"),
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
      key: _scaffoldKey,
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
            // Positioned(
            //   width: _width,
            //   bottom: _height * 0.12,
            // child:
            Positioned(
              // width: _width,
              top: _height * 0.08,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: _height * 0.1,
                        child: Container(
                          // color: Colors.blue,
                          height: double.infinity,
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: _width,
                          height: _height * 0.5,
                          decoration: BoxDecoration(
                            // color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  margin: EdgeInsets.only(top: _height * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.05),
                                  width: double.infinity,
                                  height: _height * 0.35,
                                  // color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MyTextFormField(
                                        name: "Full Name",
                                        controller: userName,
                                        myIcon: Icon(
                                          Icons.person_outline_rounded,
                                          size: 18,
                                          color: kprimary,
                                        ),
                                      ),
                                      MyTextFormField(
                                        name: "Email",
                                        controller: email,
                                        myIcon: Icon(
                                          Icons.mail_outline,
                                          size: 18,
                                          color: kprimary,
                                        ),
                                      ),
                                      MyTextFormField(
                                        name: "Phone",
                                        controller: phoneNumber,
                                        myIcon: Icon(
                                          Icons.phone_android_outlined,
                                          size: 18,
                                          color: kprimary,
                                        ),
                                      ),
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
                                      MyTextFormField(
                                        name: "Address",
                                        controller: address,
                                        myIcon: Icon(
                                          Icons.location_on_outlined,
                                          size: 19,
                                          color: kprimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, _height * 0.00125),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  width: double.infinity,
                                  height: _height * 0.11,
                                  // color: Colors.yellow,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: _width * 0.55,
                                        height: _height * 0.06,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(),
                                              primary: kprimary),
                                          child: Text("Sign Up"),
                                          onPressed: () {
                                            validation();
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: _width * 0.1),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        height: _height * 0.05,
                                        // color: Colors.amber,
                                        width: _width * 0.48,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Already a Member? ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  TansitionWidget(
                                                      widget: SignIn(),
                                                      alignment:
                                                          Alignment.topRight),
                                                );
                                              },
                                              child: Text(
                                                "Sign In",
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
                    ],
                  ),
                ),
              ],
            ),
            // ),

            Positioned(
              width: 70,
              right: 0,
              top: _width * 0.1,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      TansitionWidget(
                        widget: SignIn(),
                        alignment: Alignment.topRight,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
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
