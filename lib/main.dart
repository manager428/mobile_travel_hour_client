// read the doc first, and then run

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/blog_bloc.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';
import 'package:travel_hour/blocs/comments_bloc.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/nearby_places_bloc.dart';
import 'package:travel_hour/blocs/place_bloc.dart';
import 'package:travel_hour/blocs/popular_places_bloc.dart';
import 'package:travel_hour/blocs/recent_places_bloc.dart';
import 'package:travel_hour/blocs/recommanded_places_bloc.dart';
import 'package:travel_hour/blocs/sign_in_bloc.dart';
import 'package:travel_hour/blocs/tour_bloc.dart';
import 'package:travel_hour/blocs/user_bloc.dart';
import 'package:travel_hour/pages/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogBloc>(
          create: (context) => BlogBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<PlaceBloc>(
          create: (context) => PlaceBloc(),
        ),
        ChangeNotifierProvider<PopularPlacesBloc>(
          create: (context) => PopularPlacesBloc(),
        ),
        ChangeNotifierProvider<RecentPlacesBloc>(
          create: (context) => RecentPlacesBloc(),
        ),
        ChangeNotifierProvider<RecommandedPlacesBloc>(
          create: (context) => RecommandedPlacesBloc(),
        ),
        ChangeNotifierProvider<NearByPlacesBloc>(
          create: (context) => NearByPlacesBloc(),
        ),
        ChangeNotifierProvider<TourBloc>(
          create: (context) => TourBloc(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Muli',
              appBarTheme: AppBarTheme(
                color: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                brightness:
                    Platform.isAndroid ? Brightness.dark : Brightness.light,
                textTheme: TextTheme(
                    headline6: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        fontFamily: 'Muli')),
              )),
          debugShowCheckedModeBanner: false,
          home: SplashPage()),
    );
  }
}
