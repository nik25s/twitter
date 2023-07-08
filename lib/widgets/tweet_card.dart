import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/utils/global_variables.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';

class TweetCard extends StatefulWidget {
  final snap;
  const TweetCard({required this.snap, super.key});

  @override
  State<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(right: 33),
      // boundary needed for web
      decoration: BoxDecoration(
          border: Border.all(
              color: width > webScreenSize ? Colors.grey : Colors.black)),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Container(
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            child: Expanded(
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
                            fontSize: 18),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '@${user.username}',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '· 1h',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'This is a tweet hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  widget.snap['postUrl'] != null
                      ? SizedBox(
                          height: 250,
                          width: 300,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors
                                      .white, // Replace with your desired border color
                                  width:
                                      2.0, // Replace with your desired border width
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(user.photoUrl),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                ),
                              ),
                            ),
                          ))
                      : SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.white54,
                              size: 20,
                            )),
                      ),
                      Text(
                        '1',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.repeat,
                              color: Colors.white54,
                              size: 20,
                            )),
                      ),
                      Text(
                        '1',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.white54,
                              size: 20,
                            )),
                      ),
                      Text(
                        '1',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
