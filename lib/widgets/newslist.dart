import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/model/news.dart';

import 'singlenews.dart';

class newsList extends StatefulWidget {
  late String name;
  late String categories;
  newsList({required this.name, this.categories = ""});
  @override
  _newslistState createState() => _newslistState();
}

class _newslistState extends State<newsList> {
  List<NewsModel> newsList = <NewsModel>[];
  late bool isLoading = true;
  getNews(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=$query&apiKey=eb672f375cc844968196976f9c627a34";

    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["articles"].forEach((element) {
      NewsModel newsModel = NewsModel();
      newsModel = NewsModel.fromMap(element);
      newsList.add(newsModel);
    });
    setState(() {
      isLoading = false;
    });
  }

  getNewsCategories(
    String query,
  ) async {
    String url =
        "https://newsapi.org/v2/everything?q=$query&apiKey=eb672f375cc844968196976f9c627a34";

    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["articles"].forEach((element) {
      NewsModel newsModel = NewsModel();
      newsModel = NewsModel.fromMap(element);
      newsList.add(newsModel);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(widget.name),
          centerTitle: true,
        ),
        body: Container(
            // color: Colors.blue,
            child: isLoading == false
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: newsList.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {},
                        child: Singlenews(
                          isColor: false,
                          index: index,
                          chname: newsList[index].chName,
                          authname: newsList[index].author,
                          date: newsList[index].date,
                          title: newsList[index].title,
                          image: newsList[index].imageUrl,
                          desc: newsList[index].desc,
                          webUrl: newsList[index].webUrl,
                        ),
                      );
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
