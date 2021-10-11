import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/constraints.dart';
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
  Future getNews({required String query}) async {
    String tolow = query.toLowerCase();
    String name = tolow.trim();
    var url;

    url =
        "https://newsapi.org/v2/everything?q=$name&apiKey=eb672f375cc844968196976f9c627a34";

    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);

      data["articles"].forEach((element) {
        NewsModel newsModel = NewsModel();
        newsModel = NewsModel.fromMap(element);
        newsList.add(newsModel);
      });
      print("Data Fetched Easily");
      // setState(() {
      //   isloading = false;
      // });
      print("News list Length ${newsList.length}");
    } else {
      throw Exception('Failed to load album');
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: kprimary,
        title: Text(widget.name.toUpperCase()),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getNews(query: widget.name),
          builder: (context, snapshot) {
            return Container(
                // color: Colors.blue,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: newsList.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {},
                        child: Singlenews(
                          content: newsList[index].content,
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
                    }));
          }),
    );
  }
}
