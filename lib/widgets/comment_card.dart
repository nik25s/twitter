import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({required this.snap, super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String timeDifference = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    updateTimeDifference();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  // it will update time differ in every 1 minute
  void startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      updateTimeDifference();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void updateTimeDifference() {
    final DateTime tweetTime = widget.snap.data()['datePublished'].toDate();
    final DateTime currentTime = DateTime.now();
    final Duration difference = currentTime.difference(tweetTime);
    final String formattedDifference = _formatDuration(difference);

    setState(() {
      timeDifference = formattedDifference;
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Just now,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.snap.data()['profilePic'] ?? ''),
                  radius: 18,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: widget.snap.data()['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            TextSpan(
                                text: '  @${widget.snap.data()['name']}',
                                style: const TextStyle(color: Colors.white)),
                            WidgetSpan(
                              child: SizedBox(
                                  width: 10), // Adjust the width as needed
                            ),
                            TextSpan(
                              text: ' • $timeDifference',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ), // overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(widget.snap.data()['text'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.comment_bank_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '1',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.repeat,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '1',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '1',
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
      ],
    );
  }
}
