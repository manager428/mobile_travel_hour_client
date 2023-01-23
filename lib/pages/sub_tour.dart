import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:travel_hour/utils/cached_image.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:photo_view/photo_view.dart';

class SubTourPage extends StatefulWidget {
  final String youtubeUrl, placeName;
  final double lat, lng;
  final List extraTours;
  const SubTourPage({
    Key key,
    @required this.lat,
    this.lng,
    this.extraTours,
    this.youtubeUrl,
    this.placeName,
  }) : super(key: key);

  @override
  _SubTourPageState createState() => _SubTourPageState();
}

class _SubTourPageState extends State<SubTourPage> {
  String youtubeUrl;
  String description;
  int currentIndex;
  WebViewController controller;
  @override
  void initState() {
    super.initState();
    youtubeUrl = widget.youtubeUrl;
    currentIndex = -1;
    description = "";
  }

  void previousTour() {
    if (currentIndex == 0) {
      setState(() {
        currentIndex = currentIndex - 1;
        youtubeUrl = widget.youtubeUrl;
        controller.loadUrl(youtubeUrl);
        description = "";
      });
    } else {
      setState(() {
        currentIndex = currentIndex - 1;
        youtubeUrl = getYoutebeUrl(widget.extraTours[currentIndex]);
        description = widget.extraTours[currentIndex];
        controller.loadUrl(youtubeUrl);
      });
    }
  }

  void nextTour() {
    setState(() {
      currentIndex = currentIndex + 1;
      youtubeUrl = getYoutebeUrl(widget.extraTours[currentIndex]);
      description = widget.extraTours[currentIndex];
      controller.loadUrl(youtubeUrl);
    });
  }

  String getYoutebeUrl(description) {
    Pattern patYoutu = r'(?:<iframe[^>]*)(?:(?:\/>)|(?:>.*?<\/iframe>))';
    RegExp regexYoutu = new RegExp(patYoutu);
    String youtubeIframe = regexYoutu.stringMatch(description);
    String youtubeUrl;
    if (youtubeIframe != null) {
      Pattern pattern = r'(?<=src=").*?(?=[\?"])';
      RegExp regex = new RegExp(pattern);
      String tmpUrl = regex.stringMatch(youtubeIframe);
      youtubeUrl = tmpUrl != null ? tmpUrl : "";
    }
    return youtubeUrl;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    Pattern patImg = r'(?:<img[^>]*)(?:(?:\/>)|(?:>.*?<\/>))';
    RegExp regImg = new RegExp(patImg);
    String imgStr = regImg.stringMatch(this.description);
    String imgUrl = "";
    if (imgStr != null) {
      Pattern pattern = r'(?<=src=").*?(?=[\?"])';
      RegExp regex = new RegExp(pattern);
      String tmpUrl = regex.stringMatch(imgStr);
      imgUrl = tmpUrl != null ? tmpUrl : "";
    }
    String newDescription = this.description;
    if (imgUrl != "") {
      newDescription = newDescription.replaceAll(imgStr, "");
    }
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Hero(
                      tag: "subtour",
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        child: Container(
                          width: w,
                          height: 90,
                          color: Color.fromARGB(255, 38, 118, 133),
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 5, bottom: 10),
                          child: Image(
                            height: 75,
                            width: w,
                            image: AssetImage('assets/images/applogo.png'),
                            fit: BoxFit.contain,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 15,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.9),
                        child: IconButton(
                          icon: Icon(
                            LineIcons.arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: this.youtubeUrl != "",
                        child: Container(
                            height: 200,
                            child: WebView(
                                initialUrl: this.youtubeUrl,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated:
                                    (WebViewController webViewController) {
                                  controller = webViewController;
                                })),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: this.description != "",
                        child: Html(
                          data: newDescription,
                          defaultTextStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: imgUrl != "",
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10)),
                          height: 200,
                          width: w,
                          child: InkWell(
                            child: cachedImage(imgUrl, 10),
                            onTap: () {
                              showPopupWindow(
                                context,
                                gravity: KumiPopupGravity.rightBottom,
                                bgColor: Colors.grey.withOpacity(0.5),
                                clickOutDismiss: true,
                                clickBackDismiss: true,
                                customAnimation: false,
                                customPop: true,
                                customPage: false,
                                underStatusBar: true,
                                underAppBar: true,
                                offsetX: 0,
                                offsetY: 0,
                                duration: Duration(milliseconds: 200),
                                childFun: (pop) {
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    height: h,
                                    width: w,
                                    color: Colors.grey[400],
                                    child: Stack(
                                      children: <Widget>[
                                        Hero(
                                          tag: "subtour1",
                                          child: PhotoView(
                                            imageProvider: NetworkImage(imgUrl),
                                            loadingBuilder: (context, event) =>
                                                Center(
                                              child: Container(
                                                width: 20.0,
                                                height: 20.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  value: event == null
                                                      ? 0
                                                      : event.cumulativeBytesLoaded /
                                                          event
                                                              .expectedTotalBytes,
                                                ),
                                              ),
                                            ),
                                            backgroundDecoration: BoxDecoration(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                        Positioned(
                                          top: 25,
                                          left: 10,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.blue.withOpacity(0.9),
                                            child: IconButton(
                                              icon: Icon(
                                                LineIcons.arrow_left,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 165,
                        child: GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            InkWell(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              offset: Offset(5, 5),
                                              blurRadius: 2)
                                        ]),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.blueAccent[400],
                                                offset: Offset(5, 5),
                                                blurRadius: 2)
                                          ]),
                                      child: Icon(
                                        LineIcons.hand_o_left,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    left: 15,
                                    child: Text(
                                      currentIndex == -1
                                          ? 'Directions'
                                          : 'Previous',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                if (currentIndex == -1) {
                                  MapsLauncher.launchCoordinates(
                                      widget.lat, widget.lng, widget.placeName);
                                } else {
                                  previousTour();
                                }
                              },
                            ),
                            Visibility(
                              visible: widget.extraTours != null &&
                                  currentIndex < widget.extraTours.length - 1,
                              child: InkWell(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey[200],
                                                offset: Offset(5, 5),
                                                blurRadius: 2)
                                          ]),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color:
                                                      Colors.orangeAccent[400],
                                                  offset: Offset(5, 5),
                                                  blurRadius: 2)
                                            ]),
                                        child: Icon(
                                          LineIcons.hand_o_right,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      left: 15,
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  nextTour();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
