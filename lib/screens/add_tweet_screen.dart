import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/providers/user_providers.dart';

import '../models/user.dart';

class AddTweetScreen extends StatefulWidget {
  const AddTweetScreen({super.key});

  @override
  State<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends State<AddTweetScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        title: Text('Add Tweet'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Tweet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ))
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
              ),
              // Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 17),
              // child:
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'What\'s happening?',
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 17),
                      border: InputBorder.none,
                      hintMaxLines: 2),
                  maxLines: 8,
                ),
              ),
              // ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://e7.pngegg.com/pngimages/85/114/png-clipart-avatar-user-profile-male-logo-profile-icon-hand-monochrome-thumbnail.png'),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
