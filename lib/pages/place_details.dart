import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/blocs/bookmark_bloc.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/place_bloc.dart';
import 'package:travel_hour/pages/upload_images.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/snacbar.dart';
import 'package:travel_hour/utils/toast.dart';
import 'package:travel_hour/widgets/other_places.dart';
import 'package:travel_hour/widgets/todo.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsPage extends StatefulWidget {
  final String placeName, location, timestamp, description, tag;
  final double lat, lng;
  final List images;
  final List extraImages;

  const PlaceDetailsPage({
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
  }) : super(key: key);

  @override
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  List<dynamic> uploadedImages = new List<dynamic>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  String uid;
  int _addState = 0;
  
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      final PlaceBloc pb = Provider.of<PlaceBloc>(context);
  
      pb.loveIconCheck(widget.timestamp);
      pb.bookmarkIconCheck(widget.timestamp);
      pb.getLovesAmount(widget.timestamp);
      pb.getCommentsAmount(widget.timestamp);
      getUploadedImageList(widget.timestamp);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      email = sp.getString('email');
      uid = sp.getString('uid');
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
  List<Widget> getAddsImage(List<dynamic> addsImage1) {
    List<Widget> imgList = new List<Widget>();
    

    for (var x in addsImage1) {
      imgList.add(cachedImage(x, 0));
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

  Future<void> _makePhoneCall(String strPhone) async {
    String phone = strPhone.replaceAll(new RegExp(r'[^0-9]'), "");
    print(phone);
    if (await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      // throw 'Could not launch $url';
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      // throw 'Could not launch $url';
    }
  }

  Future getUploadedImageList(timestamp) async {
    final DocumentReference ref =
        Firestore.instance.collection('places').document(timestamp);
    DocumentSnapshot snap = await ref.get();
    List d = snap.data['uploaded-images'];

    setState(() {
      uploadedImages = d != null ? d : uploadedImages;
    });
  }

  Future _pickImage() async {
    var imagepicked = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imagepicked != null) {
      File imgFile = imagepicked;
      setState(() {
        _addState = 1;
      });
      _uploadImage(imgFile).then((value) {
        _updateData().then((_) {
          openSnacbar(scaffoldKey, 'Uploaded Successfully');
          setState(() {
            _addState = 0;
          });
        }).catchError((_) {
          setState(() {
            _addState = 0;
          });
        });
      });
    } else {
      print('No image has is selected!');
    }
  }

  Future _uploadImage(imgFile) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    String imgName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Uploaded Pictures/$imgName');
    StorageUploadTask uploadTask = storageReference.putFile(imgFile);
    if (uploadTask.isComplete) {
      print('upload complete');
    }
    var _url = await (await uploadTask.onComplete).ref.getDownloadURL();
    var _imageUrl = _url.toString();
    setState(() {
      uploadedImages.insert(0, {'imgUrl': _imageUrl, 'uid': _uid});
    });
  }

  Future _updateData() async {
    await Firestore.instance
        .collection('places')
        .document(widget.timestamp)
        .updateData({
      'uploaded-images': uploadedImages,
    });
  }

  Future _deleteImage(index) async {
    var temp = uploadedImages[index]["imgUrl"];
    setState(() {
      uploadedImages.removeAt(index);
    });
    _updateData().then((_) {
      FirebaseStorage.instance.getReferenceFromUrl(temp).then((res) {
        res.delete().then((res) {
          print("Deleted!");
        });
      });
    });
  }

  Widget setupChildAddButton() {
    if (_addState == 0) {
      return FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
          textColor: Colors.white,
          color: Colors.blueAccent,
          onPressed: () {
            _pickImage();
          },
          icon: Icon(
            Icons.camera_alt,
            size: 18,
          ),
          label: Text(
            'Add Photo',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
        )
      );
    } else {
      return FlatButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        textColor: Colors.white,
        color: Colors.blueAccent,
        onPressed: () {
        },
        icon: SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          )
        ),
        label: Text(
          'Uploading',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins'),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    print(pb.addsData.length);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    Pattern pattern = r'(?<=src=").*?(?=[\?"])';
    RegExp regex = new RegExp(pattern);
    String youtubeIframe = regex.stringMatch(widget.description);
    String youtubeUrl = youtubeIframe != null ? youtubeIframe : "";
    Pattern phonePattern =
        r'^\+{0,2}([\-\. ])?(\(?\d{0,3}\))?([\-\. ])?\(?\d{0,3}\)?([\-\. ])?\d{3}([\-\. ])?\d{4}';
    RegExp phoneRegex = new RegExp(phonePattern);
    String phoneNumber = phoneRegex.stringMatch(widget.description);
    String description = phoneNumber == null
        ? widget.description
        : widget.description.replaceFirst(phoneNumber, "");
    Pattern urlPattern =
        r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)";
    RegExp urlRegex = new RegExp(urlPattern);
    String urlString = urlRegex.stringMatch(widget.description);
    if (urlString != null) {
      urlString = urlString.contains('youtube.com') ? null : urlString;
    }
    description = urlString == null
        ? description
        : description.replaceFirst(urlString, "");

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Visibility(
                    visible: phoneNumber != null,
                    child: InkWell(
                      child: Text(
                        phoneNumber != null ? phoneNumber : "",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                      onTap: () => {_makePhoneCall(phoneNumber)},
                    ),
                  ),
                  Visibility(
                    visible: urlString != null,
                    child: InkWell(
                      child: Text(
                        urlString != null ? urlString : "",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue),
                      ),
                      onTap: () => {_launchInBrowser(urlString)},
                    ),
                  ),
                  Html(
                    data: '''$description''',
                    defaultTextStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: youtubeUrl != "",
                    child: Container(
                        height: 200,
                        child: WebView(
                          initialUrl: youtubeUrl,
                          javascriptMode: JavascriptMode.unrestricted,
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'All Photos',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          Container(
                            width: 130,
                            child: setupChildAddButton(),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0, bottom: 8),
                        height: 3,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      Visibility(
                        visible:
                            uploadedImages == null || uploadedImages.isEmpty
                                ? false
                                : true,
                        child: Container(
                          height: 120,
                          width: w,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: uploadedImages != null
                                  ? uploadedImages.length > 5
                                      ? 6
                                      : uploadedImages.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 5) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 120,
                                        width: w * 0.35,
                                        child: Center(
                                          child: Text(
                                            "More ...",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins'),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AllImagePage(
                                              allImgUrls: uploadedImages,
                                              email: this.email,
                                              uid: this.uid,
                                              timestamp: widget.timestamp,
                                            ),
                                          ),
                                        ).then((value) => getUploadedImageList(
                                            widget.timestamp));
                                      },
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: InkWell(
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
                                                    tag: "img$index",
                                                    child: PhotoView(
                                                      imageProvider:
                                                          NetworkImage(
                                                              uploadedImages[
                                                                      index]
                                                                  ['imgUrl']),
                                                      loadingBuilder:
                                                          (context, event) =>
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
                                                      backgroundDecoration:
                                                          BoxDecoration(
                                                              color: Colors
                                                                  .transparent),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 25,
                                                    left: 10,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors
                                                          .blue
                                                          .withOpacity(0.9),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          LineIcons.arrow_left,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
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
                                      child: Stack(
                                        children: <Widget>[
                                          Hero(
                                            tag: "img23$index",
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              height: 120,
                                              width: w * 0.35,
                                              child: cachedImage(
                                                  uploadedImages[index]
                                                      ["imgUrl"],
                                                  5),
                                            ),
                                          ),
                                          Visibility(
                                            visible: this.email ==
                                                    "southidahotourism@gmail.com" ||
                                                this.uid ==
                                                    uploadedImages[index]
                                                        ["uid"],
                                            child: Positioned(
                                              top: -7,
                                              right: -7,
                                              child: IconButton(
                                                icon: Icon(
                                                  LineIcons.trash,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Delete?',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          content: Text(
                                                              'Are you sure to delete this photo?'),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              child:
                                                                  Text('Yes'),
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    context);
                                                                _deleteImage(
                                                                    index);
                                                              },
                                                            ),
                                                            FlatButton(
                                                              child: Text('No'),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )
                                                          ],
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  todo(context, widget.timestamp, widget.lat, widget.lng,
                      widget.placeName),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: pb.addsData.length > 0,
                    child: Container(
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      height: 120,
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(3)),
                      child: Carousel(
                          dotBgColor: Colors.transparent,
                          showIndicator: false,
                          dotSize: 5,
                          dotSpacing: 15,
                          boxFit: BoxFit.cover,
                          images: getAddsImage(pb.addsData),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: pb.addsData.length > 0,
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  
                  OtherPlaces()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
