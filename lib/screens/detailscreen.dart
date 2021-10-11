import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/homapage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailScreen extends StatefulWidget {
  late String chName = "";
  late String imageUrl = "";
  late String desc = "";
  late String date = "";
  late String authorNm = "";
  late String title = "";
  late String content = "";

  late String webUrl = "";

  DetailScreen({
    required this.chName,
    required this.imageUrl,
    required this.desc,
    required this.date,
    required this.authorNm,
    required this.webUrl,
    required this.title,
    required this.content,
  });
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

late double _width, _height;

class _DetailScreenState extends State<DetailScreen> {
  // late String finalurl =
  //     "https://seekingalpha.com/news/3746417-business-leaders-warn-of-supply-chain-collapse-solar-tariffs-delayed";
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  // @override
  void initState() {
    if (widget.webUrl.toString().contains("http://")) {
      widget.webUrl =
          widget.webUrl.toString().replaceAll("http://", "https://");
    }

    super.initState();
  }

  Widget customChip({required String tag}) {
    return Theme(
      data: ThemeData(canvasColor: Colors.black12),
      child: Chip(
        label: Text(
          tag,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent, // or any other color
      ),
    );
  }

  Future show() async {}

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
        // backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // automaticallyImplyLeading: false,
              // leading: IconButton(
              //   onPressed: null,
              //   icon: Icon(Icons.arrow_back_ios_new_outlined),
              // ),
              brightness: Brightness.dark,
              expandedHeight: MediaQuery.of(context).size.height * 0.6,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                      child: widget.imageUrl == null
                          ? Image.asset("assets/galleryicon.png")
                          : FadeInImage.assetNetwork(
                              placeholder: "assets/image.png",
                              image: widget.imageUrl,
                              fit: BoxFit.cover,
                            ),
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0),
                  Positioned(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                      ),
                    ),
                    bottom: -1,
                    left: 0,
                    right: 0,
                  ),
                  Positioned(
                    bottom: _height * 0.01,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.07,
                      ),
                      height: _height * 0.18,
                      decoration: BoxDecoration(
                          // color: Colors.purple,
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Theme(
                          //   data: ThemeData(canvasColor: Colors.white54),
                          //   child: GestureDetector(
                          //     onTap: show,
                          //     child: Chip(
                          //       label: Text(
                          //         widget.chName,
                          //         style: TextStyle(
                          //           fontSize: 18,
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //       backgroundColor:
                          //           Colors.transparent, // or any other color
                          //     ),
                          //   ),
                          // ),

                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SliverList(
            //   delegate: SliverChildListDelegate(
            //     [
            //       Column(
            //         children: [
            //           Container(
            //             width: _width,
            //             // height: _height,
            //             // color: Colors.green,
            //             child: Container(
            //               width: double.infinity,
            //               // color: Colors.indigo,
            //               margin: EdgeInsets.symmetric(
            //                 horizontal: 10,
            //               ),
            //               child: Column(
            //                 children: [
            //                   Container(
            //                     width: double.infinity,
            //                     color: Colors.pink,
            //                     height: _height * 0.1,
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         customChip(tag: widget.authorNm),
            //                         customChip(tag: widget.date),
            //                         customChip(tag: "376"),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.05),
                  // color: Colors.indigo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(
                              widget.chName,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            backgroundColor: Colors.black, // or any other color
                          ),
                          Chip(
                            label: Text(
                              widget.date,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            backgroundColor: Colors.grey,
                          ),
                        ],
                      ),
                      SizedBox(height: _height * 0.02),
                      Text(
                        "Author Name: ",
                        maxLines: 2,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                      widget.authorNm != ""
                          ? Text(
                              widget.authorNm,
                              maxLines: 2,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            )
                          : Text(
                              "Unkown",
                              maxLines: 2,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                      SizedBox(height: _height * 0.02),
                      Text(
                        "Description: ",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                      widget.desc == ""
                          ? Text(
                              "Not Available",
                              maxLines: 2,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            )
                          : Text(
                              widget.desc,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                      SizedBox(height: _height * 0.02),
                      Text(
                        "Content: ",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                      widget.content == ""
                          ? Text(
                              "Not Available",
                              maxLines: 2,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            )
                          : Text(
                              widget.content,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
            // child: WebView(
            //   debuggingEnabled: false,
            //   initialUrl: widget.webUrl,
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onWebViewCreated: (WebViewController webViewController) {
            //     setState(() {
            //       controller.complete(webViewController);
            //     });
            //   },
            // ),
          ],
        )
        // ],
        // ),
        // ),
        // ],
        // ),
        );
  }
}
