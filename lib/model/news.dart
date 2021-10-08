import 'timeago.dart';

class NewsModel {
  late String chName;
  late String imageUrl;
  late String webUrl;
  late String title;
  late String author;
  late String date;
  late String desc;
  late String content;
  NewsModel({
    this.chName = "",
    this.imageUrl = "",
    this.webUrl = "",
    this.title = "",
    this.author = "",
    this.date = "",
    this.desc = "",
    this.content = "",
  });

  factory NewsModel.fromMap(Map news) {
    // print(news["publishedAt"]);
    DateTime date = DateTime.parse(news["publishedAt"]);
    print(TimeAgo.convertToAgo(date));
    String time = TimeAgo.convertToAgo(date).toString();
    return NewsModel(
      chName: news["source"]["name"] == null ? "" : news["source"]["name"],
      imageUrl: news["urlToImage"] == null ? "" : news["urlToImage"],
      webUrl: news["url"] == null ? "" : news["url"],
      title: news["title"] == null ? "" : news["title"],
      author: news["author"] == null ? "" : news["author"],
      date: time == null ? "" : time,
      desc: news["description"] == null ? "" : news["description"],
      content: news["content"] == null ? "" : news["content"],
    );
  }
}
