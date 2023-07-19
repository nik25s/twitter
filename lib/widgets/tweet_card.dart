import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter/screens/comment_screen.dart';
import 'package:twitter/utils/global_variables.dart';
import 'package:twitter/widgets/comment_card.dart';
import 'package:twitter/widgets/like_animation.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';
import '../utils/pick_image.dart';

class TweetCard extends StatefulWidget {
  final snap;
  const TweetCard({
    required this.snap,
    Key? key,
  });

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  bool isRetweeted = false;
  int retweetCount = 0;
  int commentlen = 0;

  @override
  void initState() {
    super.initState();
    retweetCount = widget.snap['retweet']?.length ?? 0;
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    isRetweeted = widget.snap['retweet']?.contains(user.uid) ?? false;
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentlen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  Future<void> handleRetweet() async {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    if (isRetweeted) {
      // Remove retweetbottom: MediaQuery.of(context).viewInsets.bottom
      await FirestoreMethods().doReTweet(
        widget.snap['postId'],
        user.uid,
        widget.snap['retweet'],
      );
      setState(() {
        isRetweeted = false;
        retweetCount--;
      });
    } else {
      // Add retweet
      await FirestoreMethods().doReTweet(
        widget.snap['postId'],
        user.uid,
        widget.snap['retweet'],
      );
      setState(() {
        isRetweeted = true;
        retweetCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    final bool hasImage = widget.snap['postUrl'] != null;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 25),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: width > webScreenSize ? Colors.grey : Colors.black,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                    .copyWith(right: 0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '@${user.username}',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(width: 5),
                        // const SizedBox(width: 5),
                        Text(
                          // '· $tweetTimeAgo',
                          '· 1h',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                        child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shrinkWrap: true,
                                      children: ['Delete']
                                          .map(
                                            (e) => InkWell(
                                              onTap: () async {
                                                FirestoreMethods().deletePost(
                                                    widget.snap['postId']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 118.0),
                            child: Icon(
                              Icons.more_horiz,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.only(right: 16),
                      alignment: widget.snap['tweet'].length <= 30
                          ? Alignment.centerLeft
                          : Alignment.topLeft,
                      child: Text(
                        widget.snap['tweet'],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (hasImage)
                      SizedBox(
                        height: 250,
                        width: 300,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Color.fromARGB(255, 58, 56, 56),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(widget.snap['postUrl']),
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CommentScreen(
                                          snap: widget.snap,
                                        )));
                              },
                              icon: Icon(
                                Icons.mode_comment_outlined,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ),
                          ),
                          Text(
                            commentlen.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: IconButton(
                              onPressed:
                                  handleRetweet, // Call handleRetweet on button press
                              icon: Icon(
                                Icons.repeat,
                                color:
                                    isRetweeted ? Colors.blue : Colors.white54,
                                size: 20,
                              ),
                            ),
                          ),
                          Text(
                            retweetCount.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: LikeAnimation(
                              isAnimating:
                                  widget.snap['likes'].contains(user.uid),
                              child: IconButton(
                                onPressed: () async {
                                  await FirestoreMethods().LikeTweet(
                                    widget.snap['postId'],
                                    user.uid,
                                    widget.snap['likes'],
                                  );
                                },
                                icon: widget.snap['likes'].contains(user.uid)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),
                          Text(
                            '${widget.snap['likes'].length}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0,
          thickness: 0,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
