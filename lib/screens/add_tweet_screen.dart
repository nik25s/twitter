import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:twitter/providers/user_providers.dart';
import 'package:twitter/resources/firestore_methods.dart';
import 'package:twitter/utils/pick_image.dart';
import 'dart:typed_data';
import '../models/user.dart';

class AddTweetScreen extends StatefulWidget {
  const AddTweetScreen({super.key});

  @override
  State<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends State<AddTweetScreen> {
  Uint8List? _file;
  final TextEditingController _tweetController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String profImage,
      {Uint8List? file}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(_tweetController.text, file, uid, username, profImage);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Tweeted', context);
        clearImage();
        cleartweet();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: (context),
        builder: ((context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.blue,
            title: Text('Upload Image', style: TextStyle(color: Colors.black)),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Upload with Camera',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Upload with Gallery',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }));
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void cleartweet() {
    setState(() {
      _tweetController.clear();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tweetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading:
            IconButton(onPressed: clearImage, icon: Icon(Icons.arrow_back)),
        title: Text('Add Tweet'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                if (_tweetController.text.isNotEmpty) {
                  postImage(user.uid, user.username, user.photoUrl,
                      file: _file);
                }
              },
              child: Text(
                'Tweet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _isLoading
                ? const LinearProgressIndicator()
                : Padding(padding: EdgeInsets.only(top: 0)),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(right: 78.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _tweetController,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                        hintText: 'What\'s happening?',
                        hintStyle:
                            TextStyle(color: Colors.white38, fontSize: 17),
                        border: InputBorder.none,
                        hintMaxLines: 2,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  // ),
                  // SizedBox(
                  //   height: 45,
                  //   width: 45,
                  //   child: _file != null
                  //       ? AspectRatio(
                  //           aspectRatio: 487 / 451,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               image: DecorationImage(
                  //                 image: MemoryImage(_file!),
                  //                 fit: BoxFit.fill,
                  //                 alignment: FractionalOffset.topCenter,
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       : Container(),
                  // )
                ],
              ),
            ),
            // SizedBox(height: 1),
            // SizedBox(
            //   height: 340,
            //   width: 280,
            //   child:
            _file != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 340,
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectImage(context),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 33,
        ),
      ),
    );
  }
}
