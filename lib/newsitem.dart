import 'package:JapanK/utils.dart';
import 'package:flutter/material.dart';
import 'package:JapanK/newsmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsItem extends StatelessWidget {
  final News info;
  NewsItem({@required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(info.imageUrl),
      isThreeLine: true,
      title: Text(info.title),
      subtitle: Text(info.categories + '\n' + info.date),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: WebView(
                initialUrl: info.pageUrl,
                javascriptMode: JavascriptMode.unrestricted),
          );
        }));
      },
    );
  }
}

List<Widget> newsListBuilder(List<News> allNews, {int count = -1}) {
  List<Widget> list = [];
  int max = count > 0 ? count : allNews.length;
  int cur = 0;
  for (News news in allNews) {
    if (++cur > max) break;
    list.add(NewsItem(info: news));
  }
  return list;
}

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Future<List<News>> allNews;
  ScrollController _scrollController = ScrollController();
  int length = 10;

  @override
  void initState() {
    super.initState();
    allNews = fetchNewsList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent)
        setState(() {
          this.length += 10;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          allNews = fetchNewsList();
        });
        return null;
      },
      child: FutureBuilder(
        future: allNews,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                children: newsListBuilder(snapshot.data, count: length));
          } else if (snapshot.hasError)
            return ErrorHandler(error: snapshot.error);
          else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
