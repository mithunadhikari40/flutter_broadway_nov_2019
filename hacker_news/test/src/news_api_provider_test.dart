import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hacker_news/src/resources/news_api_provider.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('simple summation test', () {
    var first = 123;
    var second = 234;
    var sum = first + second;

    expect(357, sum);
  });

  test('fetch topIds method test', () async {
    var list = [100, 200, 300, 400];
    var newsApiProvider = NewsApiProvider();

    newsApiProvider.client = MockClient((Request request) async {
      var data = jsonEncode(list);
      return Response(data, 200);
    });

    var response = await newsApiProvider.fetchTopIds();
    expect(list, response);
  });

  test('test for fetchItem function', () async {
    var data = """
    {
  "by" : "fyp",
  "id" : 21799304,
  "parent" : 21798851,
    "kids" : [ 126822, 126823, 126993, 126824, 126934, 127411, 126888, 127681, 126818, 126816, 126854, 127095, 126861, 127313, 127299, 126859, 126852, 126882, 126832, 127072, 127217, 126889, 127535, 126917, 126875 ],
  "text" : "I struggled through graduate analysis and measure theory as prereqs",
  "time" : 1576447537,
  "type" : "comment"
}
    """;

    var newsApiProvider = NewsApiProvider();
    newsApiProvider.client = MockClient((Request request) async {
      return Response(data, 200);
    });
    var response = await newsApiProvider.fetchItem(21799304);
    expect(response.id, 21799304);
  });
}
