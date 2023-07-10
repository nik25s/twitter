import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String tweet;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String? postUrl;
  final String profImage;
  final likes;
  final retweet;

  const Post({
    required this.tweet,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    this.postUrl,
    required this.profImage,
    required this.likes,
    required this.retweet,
  });

  Map<String, dynamic> toJson() => {
        "tweet": tweet,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
        "retweet": retweet,
      };

  Map<String, dynamic> toJsonWithoutUrl() => {
        "tweet": tweet,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
        "retweet": retweet,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      tweet: snapshot['tweet'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      retweet: snapshot['retweet'],
    );
  }
}
