import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';

import 'package:travel_hour/models/variables.dart';
import 'package:travel_hour/pages/blog_details.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/pages/tour_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/next_screen.dart';

class BookmarkPage extends StatefulWidget {
  BookmarkPage({Key key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((f) {
      final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);
      bb.getPlaceData();
      bb.getBlogData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text("Bookmarks"),
            bottom: TabBar(
              labelPadding: EdgeInsets.all(0),
              //indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[500], //niceish grey
              isScrollable: false,
              labelStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.w600),

              indicator: MD2Indicator(
                indicatorHeight: 2,
                indicatorColor: Colors.grey,
                indicatorSize: MD2IndicatorSize.normal,
              ),
              tabs: <Widget>[
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Text('Saved Places')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Text('Saved Blogs')
                    ],
                  ),
                ),
              ],
            )),
        body: TabBarView(
          children: <Widget>[
            bb.placeData.length == 0 ? _emptyUI() : PlaceUI(),
            bb.blogData.length == 0 ? _emptyUI() : BlogUI()

            //blogBloc.blogListInt.isEmpty ? _emptyUI(w,h) : _blogUI(w,h, context, blogBloc),
          ],
        ),
      ),
    );
  }

  Widget _emptyUI() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            height: 200,
            width: 200,
            image: AssetImage('assets/images/empty.png'),
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No Saved Items',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class PlaceUI extends StatelessWidget {
  const PlaceUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);
    double w = MediaQuery.of(context).size.width;
    return ListView.builder(
      padding: EdgeInsets.only(left: 5, right: 5),
      itemCount: bb.placeData.length,
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                    child: InkWell(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomRight,
                        height: 160,
                        width: w,
                        //color: Colors.cyan,
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                alignment: Alignment.topLeft,
                                height: 120,
                                width: w * 0.87,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 2,
                                      offset: Offset(5, 5),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 15, left: 110),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        bb.placeData[index]['place name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: titleTextStyle,
                                      ),
                                      Text(
                                        bb.placeData[index]['location'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: subtitleTextStyle,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 8, bottom: 20),
                                        height: 2,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            LineIcons.heart,
                                            size: 18,
                                            color: Colors.orangeAccent,
                                          ),
                                          Text(
                                            bb.placeData[index]['loves']
                                                .toString(),
                                            style: textStylicon,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            LineIcons.comment_o,
                                            size: 18,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            bb.placeData[index]
                                                    ['comments count']
                                                .toString(),
                                            style: textStylicon,
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 25,
                          left: 12,
                          child: Hero(
                            tag: 'bookmarkPlace$index',
                            child: Container(
                              height: 120,
                              width: 120,
                              child: cachedImage(
                                  bb.placeData[index]['image-1'], 10),
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    if (bb.placeData[index]['category'] != 4) {
                      nextScreen(
                          context,
                          PlaceDetailsPage(
                            placeName: bb.placeData[index]['place name'],
                            location: bb.placeData[index]['location'],
                            description: bb.placeData[index]['description'],
                            timestamp: bb.placeData[index]['timestamp'],
                            lat: bb.placeData[index]['latitude'],
                            lng: bb.placeData[index]['longitude'],
                            images: [
                              bb.placeData[index]['image-1'],
                              bb.placeData[index]['image-2'],
                              bb.placeData[index]['image-3']
                            ],
                            extraImages: bb.placeData[index]['extra-images'],
                            tag: 'bookmarkPlace$index',
                          ));
                    } else {
                      nextScreen(
                          context,
                          TourDetailsPage(
                            placeName: bb.placeData[index]['place name'],
                            location: bb.placeData[index]['location'],
                            description: bb.placeData[index]['description'],
                            timestamp: bb.placeData[index]['timestamp'],
                            lat: bb.placeData[index]['latitude'],
                            lng: bb.placeData[index]['longitude'],
                            images: [
                              bb.placeData[index]['image-1'],
                              bb.placeData[index]['image-2'],
                              bb.placeData[index]['image-3']
                            ],
                            extraImages: bb.placeData[index]['extra-images'],
                            extraTours: bb.placeData[index]['extra-tours'],
                            tag: 'tour$index',
                          ));
                    }
                  },
                ))));
      },
    );
  }
}

class BlogUI extends StatelessWidget {
  const BlogUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);
    return ListView.separated(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),
      itemCount: bb.blogData.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                    child: InkWell(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey[200],
                              offset: Offset(2, 0))
                        ]),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: Hero(
                              tag: 'bookmarkBlog$index',
                              child: Container(
                                  child: cachedImage(
                                      bb.blogData[index]['image url'], 10)),
                            )),
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, top: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  bb.blogData[index]['title'],
                                  style: titleTextStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.access_time,
                                        size: 16, color: Colors.grey),
                                    Text(
                                      bb.blogData[index]['date'],
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Icon(Icons.favorite,
                                        size: 18, color: Colors.grey),
                                    Text(
                                      bb.blogData[index]['loves'].toString(),
                                      style: textStylicon,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    nextScreen(
                        context,
                        BlogDetailsPage(
                          title: bb.blogData[index]['title'],
                          description: bb.blogData[index]['description'],
                          imageUrl: bb.blogData[index]['image url'],
                          date: bb.blogData[index]['date'],
                          loves: bb.blogData[index]['loves'],
                          source: bb.blogData[index]['source'],
                          timestamp: bb.blogData[index]['timestamp'],
                          tag: 'bookmarkBlog$index',
                        ));
                  },
                ))));
      },
    );
  }
}
