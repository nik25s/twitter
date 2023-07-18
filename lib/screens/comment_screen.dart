import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/providers/user_providers.dart';
import 'package:twitter/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter/widgets/comment_card.dart';

import '../models/user.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({required this.snap, super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: false,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: ((context, index) =>
                  CommentCard(snap: snapshot.data!.docs[index])));
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(bottom: 9),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 24, right: 8),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: 'reply as ${user.username}',
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FirestoreMethods().tweetComment(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl);
                setState(() {
                  _commentController.text = "";
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                  'Tweet',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
