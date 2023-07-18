import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload post
  Future<String> uploadPost(String tweet, Uint8List? file, String uid,
      String username, String profImage) async {
    String res = 'some error occurred';
    try {
      String? photoUrl;
      if (file != null) {
        photoUrl =
            await StorageMethods().uploadImageToStorage('posts', file, true);
      }

      String postId = const Uuid().v1();

      Post post = Post(
        tweet: tweet,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        retweet: [],
      );

      // if (photoUrl != null) {
      _firestore.collection('posts').doc(postId).set(post.toJson());
      // } else {
      // _firestore.collection('posts').doc(postId).set(post.toJsonWithoutUrl());
      // }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> LikeTweet(String postId, String uid, List<dynamic> likes) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      if (likes.contains(uid)) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> doReTweet(
      String postId, String uid, List<dynamic> retweet) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      if (retweet.contains(uid)) {
        await postRef.update({
          'retweet': FieldValue.arrayRemove([uid]),
          'retweetCount': FieldValue.increment(-1),
        });
      } else {
        await postRef.update({
          'retweet': FieldValue.arrayUnion([uid]),
          'retweetCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> tweetComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'commentId': commentId,
          // 'postId': postId,
          'text': text,
          'uid': uid,
          'name': name,
          'profilePic': profilePic,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
