import 'package:flutter/material.dart';
import 'package:twitter/screens/profile_screen.dart';
import 'package:twitter/screens/tweet_screen.dart';
import 'package:twitter/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  TweetScreen(),
  SearchScreen(),
  ProfileScreen(),
  // app(),
  Text('notification'),
  Text('message'),
];
