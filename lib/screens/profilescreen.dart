import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:news_app/constraints.dart';
import 'package:news_app/model/usermodel.dart';
import 'package:news_app/widgets/mytextformfield.dart';

import 'signin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

late double _height, _width;
bool edit = false;
bool isMale = false;
bool validateUser = false;
User? user;

class _ProfileScreenState extends State<ProfileScreen> {
  var _pickedImage;
  var _image;
  late UserModel userModel;
  late TextEditingController userName;
  late TextEditingController phoneNumber;
  late TextEditingController address;
  bool isMale = false;

  String userUid = "";
  void getUserUid() {
    User? myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser!.uid;
  }

  void vaildation() async {
    if (userName.text.isEmpty && phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (userName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Is Empty "),
        ),
      );
    } else if (userName.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6 "),
        ),
      );
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.length > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 11 "),
        ),
      );
    } else {
      if (_pickedImage != null) {
        finalValidation();
      }
      userDetailUpdate();
    }
  }

  void finalValidation() async {
    await _uploadImage(image: _pickedImage);

    userDetailUpdate();
  }

  String imageUrl = "";

  Future<void> userDetailUpdate() async {
    User? myUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("User").doc(myUser!.uid).update({
      "UserName": userName.text,
      "PhoneNumber": phoneNumber.text,
      "UserImage": imageUrl == "" ? "" : imageUrl,
      "UserAddress": address.text,
    });
  }

  Future<void> getImage({required ImageSource source}) async {
    _image = (await ImagePicker().pickImage(source: source))!;

    if (_image != null) {
      setState(() {
        _pickedImage = File(_image.path);
      });
    }
  }

  Future<void> _uploadImage({required File image}) async {
    User? user = FirebaseAuth.instance.currentUser;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("UserImage/$userUid");

    await storageReference.putFile(image);

    imageUrl = await storageReference.getDownloadURL();
    print(imageUrl + "Heloo Weorld");
  }

  Future<void> myDialogBox() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Pick From Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Pick From Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildSingleContianer(Icon icon, String startName, String endName) {
    return Card(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(30),
      // ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        width: _width,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    icon,
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      startName,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                endName,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainerPart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildSingleContianer(Icon(LineAwesomeIcons.user_shield, size: 25),
            "Name", userModel.UserName),
        buildSingleContianer(Icon(LineAwesomeIcons.envelope, size: 25), "Email",
            userModel.UserEmail),

        buildSingleContianer(Icon(LineAwesomeIcons.phone, size: 25), "Phone",
            userModel.UserPhoneNumber),
        buildSingleContianer(Icon(Icons.location_on_outlined, size: 25),
            "Address", userModel.UserAddress)
        // buildSingleContianer(
        //     Icon(
        //       LineAwesomeIcons.male,
        //       size: 25,
        //     ),
        //     "Gender",
        //     "Male"),
      ],
    );
  }

  Widget _buildTextFormFieldPart() {
    userName = TextEditingController(text: userModel.UserName);
    phoneNumber = TextEditingController(text: userModel.UserPhoneNumber);

    address = TextEditingController(text: userModel.UserAddress);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyTextFormField(
          name: "UserName",
          controller: userName,
          myIcon: Icon(
            LineAwesomeIcons.male,
            size: 25,
          ),
        ),
        // TextField(
        //   controller: _controller,
        //   focusNode: _focus,
        // ),
        // buildSingleContianer("Email", userModel.UserEmail),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(userModel.UserEmail),
            ],
          ),
        ),

        MyTextFormField(
          name: "PhoneNumber",
          controller: phoneNumber,
          myIcon: Icon(
            LineAwesomeIcons.phone,
            size: 25,
          ),
        ),
        MyTextFormField(
          name: "Address",
          controller: address,
          myIcon: Icon(
            Icons.location_on_outlined,
            size: 25,
          ),
        ),
      ],
    );
  }

  checkUser() {
    if (user != null) {
      getUserUid();
      setState(() {
        validateUser = true;
      });
    }
  }

  showAlertDialog(BuildContext ctx) {
    // set up the buttons

    Widget yesBtn = TextButton(
      child: Text("Yes"),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        print("SignIn Out");
        setState(() {
          validateUser = false;
        });
        Navigator.of(ctx).pop();
      },
    );
    Widget noBtn = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        yesBtn,
        noBtn,
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

  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = FirebaseFirestore.instance.collection("User").snapshots();
  }

  User? myUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    user = FirebaseAuth.instance.currentUser;
    checkUser();

    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xff087ee1),
        //     Color(0xff05e8ba),
        //   ],
        //   begin: Alignment.topRight,
        //   end: Alignment.topLeft,
        // ),
        color: kprimary,
      ),
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      width: _width,
                      child: Container(
                        width: _width,
                        height: _height * 0.68,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: _width * 0.3,
                                  width: _width * 0.3,
                                  decoration: BoxDecoration(
                                    // color: Colors.blue,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/user.png",
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => SignIn(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff455a64),
                                ),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: validateUser == true
                    ? StreamBuilder<QuerySnapshot>(
                        stream: stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;

                              if (data["UserId"] == userUid) {
                                print("yes");
                                print(data["UserId"]);
                                userModel = UserModel(
                                  UserName: data["UserName"],
                                  UserAddress: data["UserAddress"],
                                  UserEmail: data["Email"],
                                  UserPhoneNumber: data["PhoneNumber"],
                                  UserImage: data["UserImage"],
                                );
                                print("Getting image from source : ");
                                imageUrl = data["UserImage"];
                                return Container(
                                  width: _width,
                                  height: _height,
                                  child:
                                      //  validateUser == true ?
                                      Stack(
                                    children: [
                                      edit == false
                                          ? Positioned(
                                              // width: _width * 0.1,
                                              right: 5,
                                              top: _width * 0.08,
                                              child: IconButton(
                                                  onPressed: () {
                                                    showAlertDialog(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.logout,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )),
                                            )
                                          : Container(),
                                      Positioned(
                                        top: _height * 0.247,
                                        width: _width,
                                        child: Container(
                                          width: _width,
                                          height: _height * 0.67,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: _height * 0.15,
                                        width: _width,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //       blurRadius: 2,
                                            //       color: Colors.white,
                                            //       spreadRadius: 2)
                                            // ],
                                          ),
                                          child: CircleAvatar(
                                              radius: 70,
                                              backgroundColor: Colors.white,
                                              child: ClipOval(
                                                child: (_pickedImage == null)
                                                    ? (userModel.UserImage ==
                                                            "")
                                                        ? Image.asset(
                                                            "assets/galleryicon.png")
                                                        : Image.network(
                                                            userModel.UserImage,
                                                            fit: BoxFit.cover,
                                                            height:
                                                                _height * 0.17,
                                                            width:
                                                                _height * 0.17,
                                                          )
                                                    : Image.file(
                                                        _pickedImage,
                                                        fit: BoxFit.cover,
                                                        height: _height * 0.17,
                                                        width: _height * 0.17,
                                                      ),
                                              )),
                                        ),
                                      ),
                                      edit == true
                                          ? Positioned(
                                              top: _height * 0.25,
                                              right: _width * 0.27,
                                              child: GestureDetector(
                                                child: CircleAvatar(
                                                  maxRadius: 30,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                ),
                                                onTap: () {
                                                  myDialogBox();
                                                },
                                              ),
                                            )
                                          : Container(),
                                      edit == true
                                          ? Positioned(
                                              top: _height * .035,
                                              left: _width * 0.04,
                                              child: IconButton(
                                                icon: Icon(Icons.arrow_back_ios,
                                                    size: 25),
                                                onPressed: () {
                                                  setState(() {
                                                    edit = false;
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(),
                                      edit == true
                                          ? Positioned(
                                              top: _height * .035,
                                              right: _width * 0.04,
                                              child: IconButton(
                                                icon: Icon(
                                                    LineAwesomeIcons.user_check,
                                                    size: 30),
                                                onPressed: () {
                                                  setState(() {
                                                    vaildation();

                                                    edit = false;
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(),
                                      Positioned(
                                        top: _height * 0.35,
                                        width: _width,
                                        child: Container(
                                          height: _height * 0.35,
                                          decoration: BoxDecoration(
                                              // color: Colors.yellow,
                                              ),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              height: _height * 0.4,
                                              // color: Theme.of(context).backgroundColor,
                                              child: edit == true
                                                  ? _buildTextFormFieldPart()
                                                  : _buildContainerPart(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      edit == false
                                          ? Positioned(
                                              bottom: _height * 0.22,
                                              right: _width * 0.3,
                                              left: _width * 0.3,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xff05e8ba),
                                                        Color(0xff087ee1),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                    ),
                                                  ),
                                                  height: _height * 0.05,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(kprimary),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          // side: BorderSide(color: Colors.red),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text("Edit Profile"),
                                                    onPressed: () {
                                                      setState(() {
                                                        edit = true;
                                                      });
                                                    },
                                                  )),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              } else {
                                print("Id doesn't Match");
                                return Container();
                              }
                            }).toList(),
                          );
                        }
                        //

                        )
                    : Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => SignIn(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              child: Text(
                                "Sign In",
                                style: TextStyle(fontSize: 35),
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
