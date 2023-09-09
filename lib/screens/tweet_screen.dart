import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/screens/profile_screen.dart';
import 'package:twitter/utils/global_variables.dart';
import 'package:twitter/widgets/tweet_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';
import 'package:twitter/widgets/drawer_list.dart';

class TweetScreen extends StatefulWidget {
  const TweetScreen({super.key});

  @override
  State<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final width = MediaQuery.of(context).size.width;
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState?.openDrawer();
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
            ),
          ),
          title: Image.asset(
            'assets/logo.png',
            height: 40,
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Divider(
              color: Colors.grey,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.black,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Scrollbar(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Container(
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.white)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(user.photoUrl),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                user.username,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text('@${user.username}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14)),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '130',
                                      style: TextStyle(fontSize: 15)),
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: 3,
                                  )),
                                  TextSpan(
                                      text: 'Following',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: 9,
                                  )),
                                  TextSpan(
                                      text: '220',
                                      style: TextStyle(fontSize: 15)),
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: 3,
                                  )),
                                  TextSpan(
                                      text: 'Followers',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14)),
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    )),
                Divider(
                  color: Colors.grey[800],
                ),
                SizedBox(
                  height: 20,
                ),
                DrawerList(
                  icon: Icons.person_outline,
                  name: 'Profile',
                ),
                DrawerList(
                  // icon: FlutterIcons.hashtag_faw5s,
                  icon: Icons.travel_explore_outlined,
                  name: 'Topics',
                ),
                DrawerList(
                  icon: Icons.bookmark_border,
                  name: 'Bookmarks',
                ),
                DrawerList(
                  icon: Icons.list_alt_outlined,
                  name: 'Lists',
                ),
                DrawerList(
                  icon: Icons.person_add_alt_1_outlined,
                  name: 'Twitter Circle',
                ),
                SizedBox(
                  height: 50,
                  child: Divider(
                    color: Colors.grey[800],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 29.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Professional Tools',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Settings & Support',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(height: 17),
                      Icon(
                        Icons.nights_stay,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
              ],
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
                  child: TweetCard(
                    snap: snapshot.data!.docs[index].data(),
                  )),
            );
          },
        ));
  }
}
