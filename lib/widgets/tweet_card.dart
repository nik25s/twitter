import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/resources/firestore_methods.dart';
import 'package:twitter/screens/comment_screen.dart';
import 'package:twitter/utils/global_variables.dart';
import 'package:twitter/widgets/comment_card.dart';
import 'package:twitter/widgets/like_animation.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';

// class TweetCard extends StatefulWidget {
//   final snap;
//   const TweetCard({required this.snap, super.key});

//   @override
//   State<TweetCard> createState() => _TweetCardState();
// }

// class _TweetCardState extends State<TweetCard> {
//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       margin: EdgeInsets.only(right: 33),
//       // boundary needed for web
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: width > webScreenSize ? Colors.grey : Colors.black)),
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
//                 .copyWith(right: 0),
//             child: Container(
//               child: CircleAvatar(
//                 radius: 25,
//                 backgroundImage: NetworkImage(user.photoUrl),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Container(
//             child: Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         user.username,
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18),
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         '@${user.username}',
//                         style: TextStyle(color: Colors.grey, fontSize: 16),
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         '· 1h',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     'This is a tweet hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
//                     style: TextStyle(color: Colors.white),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 10,
//                   ),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   widget.snap['postUrl'] != null
//                       ? SizedBox(
//                           height: 250,
//                           width: 300,
//                           child: AspectRatio(
//                             aspectRatio: 1,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(18),
//                                 border: Border.all(
//                                   color: Colors
//                                       .white, // Replace with your desired border color
//                                   width:
//                                       2.0, // Replace with your desired border width
//                                 ),
//                                 image: DecorationImage(
//                                   image: NetworkImage(user.photoUrl),
//                                   fit: BoxFit.fill,
//                                   alignment: FractionalOffset.topCenter,
//                                 ),
//                               ),
//                             ),
//                           ))
//                       : SizedBox(height: 5),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 28.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.mode_comment_outlined,
//                                 color: Colors.white54,
//                                 size: 20,
//                               )),
//                         ),
//                         Text(
//                           '1',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.repeat,
//                                 color: Colors.white54,
//                                 size: 20,
//                               )),
//                         ),
//                         Text(
//                           '1',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.favorite_border,
//                                 color: Colors.white54,
//                                 size: 20,
//                               )),
//                         ),
//                         Text(
//                           '1',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class TweetCard extends StatefulWidget {
  final snap;
  const TweetCard({required this.snap, Key? key});

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  bool isRetweeted = false;
  int retweetCount = 0;

  @override
  void initState() {
    super.initState();
    retweetCount = widget.snap['retweet']?.length ?? 0;
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    isRetweeted = widget.snap['retweet']?.contains(user.uid) ?? false;
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
                                color: Colors.white,
                                width: 2.0,
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
                            '1',
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
