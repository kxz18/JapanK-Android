import 'package:http/http.dart' as http;
import 'dart:convert';

const String NHKNEWSLIST = "https://www3.nhk.or.jp/nhkworld/data/en/news/all.json";
const String PREFIX = "https://www3.nhk.or.jp";
const String NOPIC = "https://sterlingcomputers.com/wp-content/themes/Sterling/images/no-image-found-360x260.png";

class News {
  final String id;
  final String pageUrl;
  final String imageUrl;
  final String title;
  final String description;
  final String categories;
  final String date;

  News({this.id, this.pageUrl, this.imageUrl, this.title, this.description, this.categories, this.date});

  factory News.fromJson(Map<String, dynamic> json) {
    String dateRaw = json['id'];
    String _date = dateRaw.substring(0, 4) + '-'
                 + dateRaw.substring(4, 6) + '-'
                 + dateRaw.substring(6, 8);
    String _imageUrl = json['thumbnails'] == null ? NOPIC
                      : PREFIX + json['thumbnails']['small'];
    return News(
      id: json['id'],
      pageUrl: PREFIX + json['page_url'],
      imageUrl: _imageUrl,
      title: json['title'],
      description: json['description'],
      categories: json['categories']['name'],
      date: _date
    );
  } 
}

Future<List<News>> fetchNewsList() async {
  final response = await http.get(NHKNEWSLIST);
  if (response.statusCode == 200) {
    List<News> newsList = [];
    final List data = json.decode(response.body)['data'];
    for (var item in data)
      newsList.add(News.fromJson(item));
    return newsList;
  } else throw(response.body);  //error
}