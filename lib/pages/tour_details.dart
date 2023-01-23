import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/place_bloc.dart';
import 'package:travel_hour/pages/sub_tour.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:travel_hour/utils/toast.dart';

class TourDetailsPage extends StatefulWidget {
  final String placeName, location, timestamp, description, tag;
  final double lat, lng;
  final List images;
  final List extraImages;
  final List extraTours;
  const TourDetailsPage({
    Key key,
    @required this.placeName,
    this.location,
    this.timestamp,
    this.description,
    this.lat,
    this.lng,
    this.images,
    this.tag,
    this.extraImages,
    this.extraTours,
  }) : super(key: key);

  @override
  _TourDetailsPageState createState() => _TourDetailsPageState();
}

class _TourDetailsPageState extends State<TourDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      final PlaceBloc pb = Provider.of<PlaceBloc>(context);
      pb.loveIconCheck(widget.timestamp);
      pb.bookmarkIconCheck(widget.timestamp);
      pb.getLovesAmount(widget.timestamp);
      pb.getCommentsAmount(widget.timestamp);
    });
  }

  handleLoveClick(timestamp) {
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    ib.checkInternet();
    if (ib.hasInternet == false) {
      openToast(context, 'No internet available');
    } else {
      pb.loveIconClicked(timestamp);
    }
  }

  handleBookmarkClick(timestamp) {
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    final BookmarkBloc bb = Provider.of<BookmarkBloc>(context);
    ib.checkInternet();
    if (ib.hasInternet == false) {
      openToast(context, 'No internet available');
    } else {
      pb.bookmarkIconClicked(timestamp, context);
      bb.getPlaceData();
    }
  }

  List<Widget> getCarouselImages() {
    List<Widget> imgList = new List<Widget>();
    List allImages;
    if (widget.extraImages != null) {
      allImages = widget.images + widget.extraImages;
    } else {
      allImages = widget.images;
    }

    for (var x in allImages) {
      imgList.add(cachedImageRect(x));
    }
    return imgList;
  }

  Widget cachedImageRect(imgUrl) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: 280,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Icon(
        LineIcons.photo,
        size: 30,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    Pattern patYoutu = r'(?:<iframe[^>]*)(?:(?:\/>)|(?:>.*?<\/iframe>))';
    RegExp regexYoutu = new RegExp(patYoutu);
    String youtubeIframe = regexYoutu.stringMatch(widget.description);
    String youtubeUrl = "";
    if (youtubeIframe != null) {
      Pattern pattern = r'(?<=src=").*?(?=[\?"])';
      RegExp regex = new RegExp(pattern);
      String tmpUrl = regex.stringMatch(youtubeIframe);
      youtubeUrl = tmpUrl != null ? tmpUrl : "";
    }
    Pattern patImg = r'(?:<img[^>]*)(?:(?:\/>)|(?:>.*?<\/>))';
    RegExp regImg = new RegExp(patImg);
    String imgStr = regImg.stringMatch(widget.description);
    String imgUrl = "";
    if (imgStr != null) {
      Pattern pattern = r'(?<=src=").*?(?=[\?"])';
      RegExp regex = new RegExp(pattern);
      String tmpUrl = regex.stringMatch(imgStr);
      imgUrl = tmpUrl != null ? tmpUrl : "";
    }
    String newDescription = widget.description;
    if (imgUrl != "") {
      newDescription = newDescription.replaceAll(imgStr, "");
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: widget.tag,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      height: 320,
                      width: w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Carousel(
                          dotBgColor: Colors.transparent,
                          showIndicator: true,
                          dotSize: 5,
                          dotSpacing: 15,
                          boxFit: BoxFit.cover,
                          images: getCarouselImages()),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Expanded(
                          child: Text(
                        widget.location,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                      IconButton(
                          icon: pb.loveIcon,
                          onPressed: () => handleLoveClick(widget.timestamp)),
                      IconButton(
                          icon: pb.bookmarkIcon,
                          onPressed: () =>
                              handleBookmarkClick(widget.timestamp)),
                    ],
                  ),
                  Text(widget.placeName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins')),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    height: 3,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text('${pb.loves.toString()} People love this'),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(pb.commentsCount.toString())
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Html(
                    data: newDescription,
                    defaultTextStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                                            child: CircularProgressIndicator(
                                              value: event == null
                                                  ? 0
                                                  : event.cumulativeBytesLoaded /
                                                      event.expectedTotalBytes,
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
                    height: 30,
                  ),
                ],
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: w * 0.80,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'Start Tour',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        color: Colors.black87,
                        onPressed: () {
                          print(widget.extraTours);
                          nextScreen(
                              context,
                              SubTourPage(
                                lat: widget.lat,
                                lng: widget.lng,
                                extraTours: widget.extraTours,
                                youtubeUrl: youtubeUrl,
                                placeName: widget.placeName,
                              ));
                        },
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
