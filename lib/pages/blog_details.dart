import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'package:travel_hour/blocs/blog_bloc.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/models/config.dart';
import 'package:travel_hour/pages/comments.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetailsPage extends StatefulWidget {
  final String title, description, imageUrl, date, source, tag, timestamp;
  final int loves;

  BlogDetailsPage(
      {Key key,
      @required this.title,
      this.description,
      this.imageUrl,
      this.date,
      this.source,
      this.loves,
      this.timestamp,
      this.tag})
      : super(key: key);

  @override
  _BlogDetailsPageState createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      final BlogBloc bb = Provider.of<BlogBloc>(context);
      bb.getLovesAmount(widget.timestamp);
      bb.bookmarkIconCheck(widget.timestamp);
      bb.loveIconCheck(widget.timestamp);
    });
  }

  handleLoveClick(timestamp) {
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    final BlogBloc bb = Provider.of<BlogBloc>(context);
    ib.checkInternet();
    if (ib.hasInternet == false) {
      openToast(context, 'No internet available');
    } else {
      bb.loveIconClicked(timestamp);
    }
  }

  handleBookmarkClick(timestamp) {
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    final BlogBloc bb = Provider.of<BlogBloc>(context);
    final BookmarkBloc bkb = Provider.of<BookmarkBloc>(context);
    ib.checkInternet();
    if (ib.hasInternet == false) {
      openToast(context, 'No internet available');
    } else {
      bb.bookmarkIconClicked(timestamp, context);
      bkb.getBlogData();
    }
  }

  handleSource(link) async {
    await launch(link);
  }

  @override
  Widget build(BuildContext context) {
    final BlogBloc bb = Provider.of<BlogBloc>(context);

    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, right: 0),
                  height: 56,
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          size: 22,
                        ),
                        onPressed: () {
                          Share.share(
                              '${widget.title}, To read more install ${Config().appName} App. https://play.google.com/store/apps/details?id=com.pt.lavtrip');
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            widget.date,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        height: 3,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: FlatButton.icon(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () => handleSource(widget.source),
                                  icon: Icon(LineIcons.copyright,
                                      size: 20, color: Colors.blueAccent),
                                  label: Expanded(
                                      child: Text(
                                    widget.source,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )))),
                          IconButton(
                            icon: bb.loveIcon,
                            onPressed: () {
                              handleLoveClick(widget.timestamp);
                            },
                          ),
                          IconButton(
                            icon: bb.bookmarkIcon,
                            onPressed: () async {
                              handleBookmarkClick(widget.timestamp);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: widget.tag,
                  child: Container(
                      height: 250,
                      width: w,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        '${bb.loves.toString()} People love this',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FlatButton.icon(
                          color: Colors.green[300],
                          onPressed: () {
                            nextScreen(
                                context,
                                CommentsPage(
                                  timestamp: widget.timestamp,
                                  title: 'Comments',
                                ));
                          },
                          icon: Icon(Icons.message),
                          label: Text('Comments'))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Html(
                      defaultTextStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      data: '''  ${widget.description}   '''),
                ),
                SizedBox(
                  height: 30,
                )
              ]),
        ),
      ),
    );
  }
}
