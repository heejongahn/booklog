import 'package:flutter/material.dart';

import 'package:booklog/components/review_card/main.dart';
import 'package:booklog/models/book.dart';
import 'package:booklog/models/review.dart';
import 'package:booklog/screens/add_book/index.dart';
import 'package:booklog/utils/database_helpers.dart';

class ReviewsState extends State<Reviews> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildRows(List<Review> reviews) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reviews.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return ReviewCard(review: reviews[index], onTap: _pushSaved);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('리뷰 피드'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: FutureBuilder<List<Review>>(
          future: DatabaseHelper.instance.queryAllReviews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildRows(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _insertDummyReview,
        child: Icon(Icons.add),
      ),
    );
  }

  void _insertDummyReview() async {
    final Review review = Review(
      stars: 4,
      title: '더미 리뷰 제목',
      body: '더미 리뷰 본문',
    );

    await DatabaseHelper.instance.insertReview(review);
  }

  void _pushSaved() async {
    final book = await (Navigator.of(context).push(
      MaterialPageRoute<Book>(
        builder: (BuildContext context) {
          return AddBook();
        },
      ),
    ));

    if (book != null) {
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(book.title)));
    }
  }
}

class Reviews extends StatefulWidget {
  @override
  ReviewsState createState() => new ReviewsState();
}