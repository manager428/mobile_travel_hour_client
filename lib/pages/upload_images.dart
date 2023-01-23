import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';

import 'package:travel_hour/utils/cached_image.dart';

class AllImagePage extends StatefulWidget {
  final List allImgUrls;
  final String email, uid, timestamp;
  AllImagePage(
      {Key key,
      @required this.allImgUrls,
      this.email,
      this.uid,
      this.timestamp})
      : super(key: key);

  @override
  _AllImagePageState createState() => _AllImagePageState();
}

class _AllImagePageState extends State<AllImagePage> {
  List<dynamic> uploadedImages = new List<dynamic>();
  @override
  void initState() {
    super.initState();
    uploadedImages = widget.allImgUrls;
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

  Future _deleteAll() async {
    var temp = List.from(uploadedImages);
    setState(() {
      uploadedImages.clear();
    });

    _updateData().then((_) {
      temp.forEach((element) {
        FirebaseStorage.instance
            .getReferenceFromUrl(element['imgUrl'])
            .then((res) {
          res.delete().then((res) {
            print("Deleted!");
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(8),
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
        backgroundColor: Colors.grey[300],
        title: Text(
          'All Photos',
          style: TextStyle(
              color: Colors.grey[900],
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          Visibility(
            visible: widget.email == "southidahotourism@gmail.com",
            child: IconButton(
              icon: Icon(
                LineIcons.trash,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Delete?',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        content: Text('Are you sure to delete this all photo?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              Navigator.pop(context);
                              _deleteAll();
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          child: GridView.builder(
            itemCount: widget.allImgUrls.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                ),
                child: InkWell(
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: "img23$index",
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          height: 120,
                          width: w * 0.35,
                          child:
                              cachedImage(uploadedImages[index]["imgUrl"], 5),
                        ),
                      ),
                      Visibility(
                        visible:
                            widget.email == "southidahotourism@gmail.com" ||
                                widget.uid == uploadedImages[index]["uid"],
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
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Delete?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      content: Text(
                                          'Are you sure to delete this photo?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            _deleteImage(index);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            Navigator.pop(context);
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
                                  imageProvider: NetworkImage(
                                      uploadedImages[index]['imgUrl']),
                                  loadingBuilder: (context, event) => Center(
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
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                ),
                              ),
                              Positioned(
                                top: 25,
                                left: 10,
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
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
