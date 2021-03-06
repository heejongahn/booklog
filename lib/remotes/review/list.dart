import 'dart:async';
import 'package:flutter/foundation.dart' show describeEnum;
import 'package:galpi/models/review.dart';
import 'package:galpi/utils/env.dart';
import 'package:galpi/utils/http_client.dart';

enum ListType {
  all,
  unread,
  read,
}

Future<List<Review>> fetchReviews({
  String userId,
  int skip = 0,
  int take = 20,
  ListType listType,
}) async {
  print(describeEnum(listType));
  print(
      '${env.apiEndpoint}/review/list?userId=${userId}&skip=${skip}&take=${take}&listType=${describeEnum(listType)}');

  final response = await httpClient.get(
    '${env.apiEndpoint}/review/list?userId=${userId}&skip=${skip}&take=${take}&listType=${describeEnum(listType)}',
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  final decoded =
      httpClient.decodeBody<Map<String, dynamic>>(response.bodyBytes);

  final reviews =
      List<Map<String, dynamic>>.from(decoded['reviews'] as List<dynamic>);

  final reviewIterable = reviews.map((data) => Review.fromJson(data));
  final reviewList = reviewIterable.toList();

  return reviewList;
}
