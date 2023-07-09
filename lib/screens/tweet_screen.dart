import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/utils/global_variables.dart';
import 'package:twitter/widgets/tweet_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';

class TweetScreen extends StatelessWidget {
  const TweetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: 107,
              ),
              Image.asset(
                'assets/logo.png',
                height: 44,
              ),
            ],
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Divider(
              color: Colors.grey,
            ),
          ),
        ),
        // body: TweetCard(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width > webScreenSize ? width * 0.3 : 0,
                      vertical: width > webScreenSize ? 15 : 0),
                  child: TweetCard(snap: snapshot.data!.docs[index].data())),
            );
          },
        ));
  }
}
