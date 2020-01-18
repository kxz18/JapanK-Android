import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'global.dart';

//get suggestion list from moji
Future<List> fetchSuggestionList(String query) async {
  final response = await http.post(
    "https://api.mojidict.com/parse/functions/search_v3",
    headers: MOJISEARCHHEADERS,
    body: json.encode({
      "searchText": query,
      "needWords": true,
      "langEnv":"zh-CN_ja",
      "_ApplicationId":"E62VyFVLMiW7kvbtVq3p",
      "_ClientVersion":"js2.7.1",
      "_InstallationId":"a956f4f4-97e1-5436-d673-c46105a519f5",
      "_SessionToken": mojiSessionToken
    })
  );
  if (response.statusCode == 200) {
    List<BriefWord> result = [];
    Map<String, dynamic> jsonified = json.decode(response.body);
    print(jsonified);
    if (jsonified["result"] != null) {
      for (var item in jsonified["result"]["words"]) {
        result.add(BriefWord.fromJson(item));
      }
    }
    //this.suggestionList = result;
    return result;
  } else {
    throw("failed to connect with moji: ${response.statusCode}");
  }
}

//extract of word info
class BriefWord {
  final String excerpt;
  final String spell;
  final String accent;
  final String kana;
  final String romaji;
  final String id;

  BriefWord({this.excerpt, this.spell, this.accent, this.kana, this.romaji, this.id});

  factory BriefWord.fromJson(Map<String, dynamic> json) {
    return BriefWord(
      excerpt: json["excerpt"],
      spell: json["spell"],
      accent: json["accent"],
      kana: json["pron"],
      romaji: json["romaji"],
      id: json["objectId"]
    );
  }
}


//fetch information of the word
Future<Post> fetchPost(String wordId) async {
  final response = await http.post(
    "https://api.mojidict.com/parse/functions/fetchWord_v2",
    headers: MOJIFETCHHEADERS,
    body: {
      "wordId": wordId,
      "_ApplicationId": "E62VyFVLMiW7kvbtVq3p",
      "_ClientVersion": "js2.7.1",
      "_InstallationId": "a956f4f4-97e1-5436-d673-c46105a519f5",
      //"_SessionToken": "r:f194386ae529f49c72f3e7160c3dcada"
    }
  );
  if (response.statusCode == 200) {
    var wordInfoMap = json.decode(response.body)["result"];
    if (wordInfoMap == null) throw Exception("Word with this id cannot be found");
    return Post.fromJson(wordInfoMap);
  } else {
    throw Exception("Failed to load post");
  }
}

//class of the information of the word
class Post {
  final String excerpt;
  final String spell;           
  final String accent;
  final String kana;
  final String romaji;
  final String id;
  final List<Detail> details;  //different usage

  Post({this.excerpt, this.spell, this.accent, this.kana, this.romaji, this.id, this.details});

  factory Post.fromJson(Map<String, dynamic> json) {
    //print(json);
    Post post =  Post(
      excerpt: json["word"]["excerpt"],
      spell: json["word"]["spell"],
      accent: json["word"]["accent"],
      kana: json["word"]["pron"],
      romaji: json["word"]["romaji"],
      id: json["word"]["objectId"],
      details: []
    );
    if (json["details"] != null) {
      for (var item in json["details"]) {
        post.details.add(Detail.fromJson(item, json));
      }
    }
    return post;
  }
}

//class of different usage of the word
class Detail {
  final String title;                 //noun, verb ... and etc.
  final List<SubDetail> subdetails;  //different definations

  Detail({this.title, this.subdetails});

  factory Detail.fromJson(Map<String, dynamic> json, Map<String, dynamic> origin) {
    Detail detail = Detail(
      title: json["title"],
      subdetails: []
    );
    if (origin["subdetails"] != null) {
      for (var item in origin["subdetails"]) {
        if (item["detailsId"] == json["objectId"]) {
          detail.subdetails.add(SubDetail.fromJson(item, origin));
        }
      }
    }
    return detail;
  }
}

//class of diffrent definations of the same usage of the word
class SubDetail {
  final String title;             //meaning
  final List<Example> examples;  //samples

  SubDetail({this.title, this.examples});
  
  factory SubDetail.fromJson(Map<String, dynamic> json, Map<String, dynamic> origin) {

    SubDetail subDetail = SubDetail(
      title: json["title"],
      examples: []
    );
    if (origin["examples"] != null) {
      for (var item in origin["examples"]) {
        if (item["subdetailsId"] == json["objectId"]) {
          subDetail.examples.add(Example.fromJson(item));
        }
      }
    }
    return subDetail;
  }
}

//class of example sentences
class Example {
  final String title;
  final String trans;

  Example({this.title, this.trans});

  factory Example.fromJson(Map<String, dynamic> json) {
    return Example(
      title: json["title"],
      trans: json["trans"]
    );
  }
}

addCollectionFromString(String items) async {
  List<String> allItems = items.split(RegExp(r'\s+'));
  RegExp isNum = RegExp(r'[0-9]+');
  for (String item in allItems)
    if (isNum.stringMatch(item) == item)
      await addCollection(item);
}

//add word to collection
addCollection(String id) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  List<String> collection = storage.getStringList("Collection");
  collection.add(id);

  print("added $id");

  await storage.setStringList("Collection", collection);
}

//check if the word is in collection
Future<bool> checkInCollection(String id) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  List<String> collection = storage.getStringList("Collection");
  return collection.contains(id);
}

//remove word from collection
removeCollection(String id) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  List<String> collection = storage.getStringList("Collection");
  collection.remove(id);
  
  print("Removed $id");

  await storage.setStringList("Collection", collection);
}

//get all word id in collections
Future<Set<String>> allInCollection() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  List<String> collection = storage.getStringList("Collection");
  if (collection == null) {
    collection = [];
    storage.setStringList("Collection", collection);
  }
  return collection.toSet();
}

Future<String> outportCollection(String name) async {
  String directory = (await getApplicationDocumentsDirectory()).path;
  File file = File(directory + '\\' + name);
  print(file.path);
  if (!file.existsSync()) await file.create();
  Set<String> items = await allInCollection();
  for (String item in items) {
    await file.writeAsString(item + "\n");
  }
  return file.path;
}

//get stored session token
Future<String> getSessionToken() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  return storage.getString("SessionToken");
}

//change stored session token
changeSessionToken(String sessionToken) async {
  mojiSessionToken = sessionToken;
  SharedPreferences storage = await SharedPreferences.getInstance();
  await storage.setString("SessionToken", sessionToken);
}

//update session token from remote
Future<String> updateSessionTokenFromRemote() async {
  final response = await http.post(
    'https://api.mojidict.com/parse/login',
    headers: MOJILOGINHEADERS,
    body: {
      "username":mojiAccount,
      "password":mojiPassword,
      "_method":"GET",
      "_ApplicationId":"E62VyFVLMiW7kvbtVq3p",
      "_ClientVersion":"js2.7.1",
      "_InstallationId": "a956f4f4-97e1-5436-d673-c46105a519f5"
    }
  );
  if (response.statusCode == 200) {
    return json.decode(response.body)["sessionToken"];
  } else {
    throw('''Failed to update session Token, try manully.
          Status Code: ${response.statusCode}''');
  }
}