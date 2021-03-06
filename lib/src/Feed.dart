import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pixplace/entities/Post.dart';
import 'package:pixplace/firebase/Firestore.dart';

import 'package:pixplace/widgets/PostWidget.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.getCollection('Posts').orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (content, index) {
                return PostWidget(
                  post:
                      Post.fromJson(snapshot.data.docs.toList()[index].data()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('An error has occured, please try again later.');
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink))),
            );
          }
        },
      ),
    );
  }
}
