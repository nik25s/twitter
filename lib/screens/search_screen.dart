import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/providers/user_providers.dart';
import 'package:twitter/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter/screens/profile_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
            radius: 14,
          ),
          title: Container(
            width: 220,
            height: 40,
            child: TextFormField(
              cursorColor: Colors.blue,
              showCursor: true,
              controller: searchController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      borderSide: BorderSide(color: Colors.grey)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  focusColor: Colors.white,
                  fillColor: Colors.grey[900],
                  filled: true,
                  hintText: 'search Twitter',
                  hintStyle: TextStyle(
                    color: Colors.white60,
                  )),
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              onFieldSubmitted: (String_) {
                setState(() {
                  isShowUser = true;
                });
              },
            ),
          ),
          actions: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                ),
                SizedBox(
                  width: 17,
                ),
              ],
            )
          ],
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          // onTap: () => Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //         builder: (context) => ProfileScreen(
                          //             uid: (snapshot.data! as dynamic)
                          //                 .docs[index]['uid']))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl']),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          ),
                        );
                      }));
                }),
              )
            : Container());
  }
}
