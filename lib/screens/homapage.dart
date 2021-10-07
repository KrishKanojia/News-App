import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:news_app/constraints.dart';
import 'package:news_app/main.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/provider/userdataprovider.dart';
import 'package:news_app/widgets/frontscreen.dart';
import 'package:news_app/widgets/newslist.dart';
import 'package:news_app/widgets/singlenews.dart';
import 'package:provider/provider.dart';

import 'profilescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

late double _height, _width;
// late TabController _controller;

class _HomePageState extends State<HomePage> {
  Widget customChip({required String tag}) {
    return GestureDetector(
      onTap: () {
        print("Function in Custom Chip");
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => newsList(name: "$tag"),
            ),
          );
        });
      },
      child: Chip(
        backgroundColor: Color(0xFFE1E4F3),
        padding: const EdgeInsets.symmetric(vertical: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        label: Text(
          "#$tag",
          style: GoogleFonts.lato(
            textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  late UserDataProvider _dataProvider;
  bool isloading = true;

  List<NewsModel> newslist = <NewsModel>[];

  String news = "tesla";
  int Categories = 1;
  getNews({required String query}) async {
    var url;

    url =
        "https://newsapi.org/v2/top-headlines?q=$query&apiKey=eb672f375cc844968196976f9c627a34";

    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["articles"].forEach((element) {
      NewsModel newsModel = NewsModel();
      newsModel = NewsModel.fromMap(element);
      newslist.add(newsModel);
    });
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // introPart();
    getNews(
      query: news,
    );
  }

  introPart() {
    showAlertDialog(BuildContext ctx) {
      Widget continueButton = TextButton(
        child: Text("Continue"),
        onPressed: () {
          Navigator.of(ctx).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarIconBrightness: Brightness.dark,
    // ));
    _dataProvider = Provider.of<UserDataProvider>(
      context,
      listen: false,
    );
    // User? user = FirebaseAuth.instance.currentUser;
    // print("This is Current User $user");
    // showAlertDialog(context);
    introPart();
    _dataProvider.getFavouriteData();
    return DefaultTabController(
      length: 4,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Container(
          color: kprimary,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Infinite News",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                bottom: TabBar(
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.white,
                  isScrollable: true,
                  // controller: _controller,
                  // onTap: (index) {
                  //   if (index == 0) {
                  //     getNews(query: "tesla", categories: index);
                  //   } else if (index == 1) {
                  //     getNews(query: "amazon", categories: index);
                  //   } else if (index == 2) {
                  //     getNews(query: "amazon", categories: index);
                  //   } else if (index == 3) {
                  //     getNews(query: "amazon", categories: index);
                  //   }
                  // },
                  tabs: [
                    GestureDetector(
                      child: Text(
                        "Top Headlines",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      onTap: () {
                        tabController.animateTo(tabController.index = 0);
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "Top Stories",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      onTap: () {
                        tabController.animateTo(tabController.index = 1);
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "Popular News",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      onTap: () {
                        tabController.animateTo(tabController.index = 2);
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "Sports News",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 20),
                        ),
                      ),
                      onTap: () {
                        tabController.animateTo(tabController.index = 3);
                      },
                    ),
                    // topTab(categories: "Top Headlines", name: "tesla"),
                    // topTab(categories: "Top", name: "tesla"),
                    // Text(
                    //   "Popular News",
                    //   style: GoogleFonts.lato(
                    //     textStyle: TextStyle(fontSize: 20),
                    //   ),
                    // ),
                    // Text(
                    //   "Sport News",
                    //   style: GoogleFonts.lato(
                    //     textStyle: TextStyle(fontSize: 20),
                    //   ),
                    // ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: ScrollPhysics(),
                    child:
                        // FrontScreen(),
                        Column(
                      children: [
                        // Container(
                        //   color: kprimary,
                        //   width: _width,
                        //   height: _height * 0.1,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       // Center(
                        //       //   child: Text(
                        //       //     "Infinite News",
                        //       //     style: GoogleFonts.lato(
                        //       //       textStyle:
                        //       //           TextStyle(fontSize: 25, color: Colors.white),
                        //       //     ),
                        //       //   ),
                        //       // ),

                        //       // TabBarView(children: children)
                        //     ],
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              // color: Colors.teal,
                              // border: Border.symmetric(
                              //   horizontal: BorderSide(color: Colors.black12, width: 2),
                              // ),
                              ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: _width,
                          height: _height * 0.24,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _width,
                                // color: Colors.amberAccent,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Popular Tags",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: _width,
                                height: _height * 0.19,
                                // color: Colors.indigo,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        customChip(tag: "music"),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        customChip(tag: "health"),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        customChip(tag: "entertainment"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        customChip(tag: "technology"),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        customChip(tag: "apple"),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        customChip(tag: "ronaldo"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        customChip(tag: "rock"),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        customChip(tag: "pakistan"),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        customChip(tag: "pubg"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: _width,
                          height: _height * 0.05,
                          // color: Colors.green,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Icon(
                                Icons.thumb_up_off_alt_sharp,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "RECOMMENDED FOR YOU",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        isloading == false
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: newslist.length,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Singlenews(
                                      isColor: false,
                                      index: index,
                                      chname: newslist[index].chName,
                                      authname: newslist[index].author,
                                      date: newslist[index].date,
                                      title: newslist[index].title,
                                      image: newslist[index].imageUrl,
                                      desc: newslist[index].desc,
                                      webUrl: newslist[index].webUrl,
                                    ),
                                  );
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ],
                    ),
                  ),
                  FrontScreen(
                    category: "everything",
                    query: 'amazon',
                  ),
                  FrontScreen(
                    category: "everything",
                    query: 'popular',
                  ),
                  FrontScreen(
                    category: "everything",
                    query: 'sports',
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}


// backgroundColor: Colors.transparent,
            // appBar: AppBar(
            //   backgroundColor: kprimary,
            //   title: Column(
            //     children: [
            //       SizedBox(
            //         height: 10,
            //       ),
            //       Text(
            //         "Infinite News",
            //         style: GoogleFonts.lato(
            //           textStyle: TextStyle(fontSize: 25),
            //         ),
            //       ),
            //     ],
            //   ),
            //   centerTitle: true,
            //   bottom: PreferredSize(
            //     preferredSize: Size.fromHeight(_height * 0.07),
            //     child: Container(
            //       // color: Colors.blue,
            //       height: _height * 0.07,
            //       width: _width,
            //       child: TabBar(
            //         isScrollable: true,
            //         tabs: [
            //           Text(
            //             "Top Stories",
            //             style: GoogleFonts.lato(
            //               textStyle: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //           Text(
            //             "Headlines",
            //             style: GoogleFonts.lato(
            //               textStyle: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //           Text(
            //             "Popular News",
            //             style: GoogleFonts.lato(
            //               textStyle: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //           Text(
            //             "Sport News",
            //             style: GoogleFonts.lato(
            //               textStyle: TextStyle(fontSize: 20),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // bottomNavigationBar: BottomNavigationBar(
            //   items: [],
            // ),