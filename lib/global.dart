const Map<String, String> MOJISEARCHHEADERS = {
  "authority": "api.mojidict.com",
  "method": "POST",
  "path": "/parse/functions/search_v3",
  "scheme": "https",
  "accept": "*/*",
  "accept-encoding": "gzip, deflate, br",
  "accept-language": "en-CN,en-US;q=0.9,en;q=0.8,zh;q=0.7,zh-CN;q=0.6",
  "cache-control": "no-cache",
  "origin": "https://www.mojidict.com",
  "pragma": "no-cache",
  //"referer": "https://www.mojidict.com/details/198942871",
  "sec-fetch-mode": "cors",
  "sec-fetch-site": "same-site",
  "user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
};

const Map<String, String> MOJIFETCHHEADERS = {
  "authority": "api.mojidict.com",
  "method": "POST",
  "path": "/parse/functions/fetch_v2",
  "scheme": "https",
  "accept": "*/*",
  "accept-encoding": "gzip, deflate, br",
  "accept-language": "en-CN,en-US;q=0.9,en;q=0.8,zh;q=0.7,zh-CN;q=0.6",
  "cache-control": "no-cache",
  "origin": "https://www.mojidict.com",
  "pragma": "no-cache",
  //"referer": "https://www.mojidict.com/details/198942871",
  "sec-fetch-mode": "cors",
  "sec-fetch-site": "same-site",
  "user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36"
};

const Map<String, String> MOJILOGINHEADERS = {
  'authority': 'api.mojidict.com',
  'pragma': 'no-cache',
  'cache-control': 'no-cache',
  'accept': '*/*',
  'origin': 'https://www.mojidict.com',
  'sec-fetch-site': 'same-site',
  'sec-fetch-mode': 'cors',
  'referer': 'https://www.mojidict.com/',
  'accept-encoding': 'gzip, deflate, br',
  'accept-language': 'en-CN,en-US;q=0.9,en;q=0.8,zh;q=0.7,zh-CN;q=0.6',
  'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36',
};

const double STDFONTSIZE = 15;

String mojiSessionToken = "r:544dda15b81ed00a42b8a33b1586788e";
String mojiAccount = "302702295@qq.com";
String mojiPassword = "dontstareatmypassword";
