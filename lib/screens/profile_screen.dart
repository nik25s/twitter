import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:twitter/main.dart';
import 'package:provider/provider.dart';
import 'package:twitter/utils/global_variables.dart';
import 'package:twitter/widgets/tweet_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';
import 'package:twitter/widgets/drawer_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Track the current selected tab index
  int _currentTabIndex = 0;

  // Function to be called when the first tab is selected
  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  // widget to show when Tweet tab is selected
  Widget _buildTweetsTabContent(double width) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // // Filter only the posts that have at least one like
        // final likedPosts = snapshot.data!.docs.where((post) {
        //   // Assuming 'likes' is the field representing the array of likes in the document
        //   List<dynamic> likes = post['likes'];
        //   return likes.isNotEmpty;
        // }).toList();

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: width > webScreenSize ? width * 0.3 : 0,
              vertical: width > webScreenSize ? 15 : 0,
            ),
            child: TweetCard(
              snap: snapshot.data!.docs[index].data(),
              // snap: likedPosts[index].data(),
            ),
          ),
        );
      },
    );
  }

  // widget to show other content when other tab selected
  Widget _buildOtherTabContent() {
    // Widget for the content of the second tab
    // Add your code for the other tab content here
    print('other tab');
    return Container(
      child: Center(
        child: Text('Other Tab Content'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final User user = Provider.of<UserProvider>(context).getUser;
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              // this is the land image
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1682685797661-9e0c87f59c60?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Positioned(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),

              // profile pitcure
              Positioned(
                top: 110,
                left: 20,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.black12,
                    child: CircleAvatar(
                      radius: 33,
                      backgroundImage: ExactAssetImage('assets/logo.png'),
                    ),
                  ),
                ),
              ),

              // follow button
              Positioned(
                top: 158,
                left: 345,
                // padding: EdgeInsets.all(7),

                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 6, bottom: 6),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
          ),

          // username section
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'username',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '@username',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 11,
                ),
                Text(
                  'bio',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Rajasthan, India',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Joined June 2020',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          '133',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Following',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Row(
                      children: [
                        Text(
                          '53',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          DefaultTabController(
            length: 4,
            initialIndex: _currentTabIndex,
            child: TabBar(
              isScrollable: true,
              onTap: _onTabSelected,
              unselectedLabelColor: Colors.white.withOpacity(0.4),
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text(
                    'Tweets',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text('Tweet & Replies',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text('Media',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Tab(
                  child: Text('Likes',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentTabIndex == 0
                ? Container(child: _buildTweetsTabContent(width))
                : _buildOtherTabContent(),
          ),
        ],
      ),
    );
  }
}

// modify and better version of app bar
// class app extends StatelessWidget {
//   const app({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text('SliverAppBar Example'),
//               background: Image.network(
//                 'https://images.unsplash.com/photo-1682685797661-9e0c87f59c60?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) => ListTile(
//                 title: Text('List item $index'),
//               ),
//               childCount: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
