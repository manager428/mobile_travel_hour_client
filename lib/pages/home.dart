import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/blog_bloc.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';
import 'package:travel_hour/blocs/place_bloc.dart';
import 'package:travel_hour/blocs/user_bloc.dart';

import 'package:travel_hour/pages/search.dart';

import 'package:travel_hour/widgets/featured_places.dart';

import 'package:travel_hour/widgets/popular_places.dart';
import 'package:travel_hour/widgets/recent_places.dart';
import 'package:travel_hour/widgets/recommended_places.dart';
import 'package:travel_hour/widgets/tours.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName, userEmail;

  String userProfilePic = '';
  int listIndex = 0;
  int selectedCategory = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      final UserBloc ub = Provider.of<UserBloc>(context);
      final PlaceBloc pb = Provider.of<PlaceBloc>(context);
      final BlogBloc bgb = Provider.of<BlogBloc>(context);
      final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);

      ub.getUserData();
      pb.getLovedList();
      pb.getBookmarkedList();
      bgb.getLovedList();
      bgb.getBookmarkedList();
      bb.getBlogData();
      bb.getPlaceData();
    });
  }

  Widget searchBar(w) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 5),
      child: InkWell(
        child: Container(
          alignment: Alignment.centerLeft,
          height: 43,
          width: w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400], width: 0.5),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Icon(CupertinoIcons.search),
                SizedBox(
                  width: 20,
                ),
                Text('Search Places & Explore'),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
    );
  }

  Widget headerNew(w) {
    return Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        child: Container(
          width: w,
          height: 90,
          color: Color.fromARGB(255, 38, 118, 133),
          padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 10),
          child: Image(
            height: 75,
            width: w,
            image: AssetImage('assets/images/applogo.png'),
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        ));
  }

  Widget categoryButtons(w) {
    return Container(
        padding: EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 0),
        color: Color.fromARGB(255, 192, 192, 192),
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonPadding: EdgeInsets.symmetric(horizontal: 0),
          children: <Widget>[
            FlatButton(
              color: Colors.transparent,
              textColor: Colors.black,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                if (selectedCategory != 1) {
                  setState(() {
                    selectedCategory = 1;
                  });
                }
              },
              child: Text(
                "Adventures",
                style: TextStyle(
                    fontWeight: selectedCategory == 1
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
            FlatButton(
              color: Colors.transparent,
              textColor: Colors.black,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                if (selectedCategory != 2) {
                  setState(() {
                    selectedCategory = 2;
                  });
                }
              },
              child: Text(
                "Lodging",
                style: TextStyle(
                    fontWeight: selectedCategory == 2
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
            FlatButton(
              color: Colors.transparent,
              textColor: Colors.black,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                if (selectedCategory != 3) {
                  setState(() {
                    selectedCategory = 3;
                  });
                }
              },
              child: Text(
                "Food",
                style: TextStyle(
                    fontWeight: selectedCategory == 3
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
            FlatButton(
              color: Colors.transparent,
              textColor: Colors.black,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                if (selectedCategory != 4) {
                  setState(() {
                    selectedCategory = 4;
                  });
                }
              },
              child: Text(
                "Tours",
                style: TextStyle(
                    fontWeight: selectedCategory == 4
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          //backgroundColor: Colors.white,
          body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            headerNew(w),
            categoryButtons(w),
            // searchBar(w),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: selectedCategory != 4,
              child: Featured(category: selectedCategory),
            ),
            Visibility(
              visible: selectedCategory != 4,
              child: PopularPlaces(category: selectedCategory),
            ),
            Visibility(
              visible: selectedCategory != 4,
              child: RecentPlaces(category: selectedCategory),
            ),
            selectedCategory != 4
                ? RecommendedPlaces(category: selectedCategory)
                : Tours()
          ],
        ),
      )),
    );
  }
}
