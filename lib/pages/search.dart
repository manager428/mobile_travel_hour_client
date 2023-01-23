import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/place_bloc.dart';
import 'package:travel_hour/models/variables.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/next_screen.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String txt = 'SUGGESTED PLACES';
  var formKey = GlobalKey<FormState>();
  var textFieldCtrl = TextEditingController();

  Widget beforeSearchUI() {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    double w = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5),
        itemCount: pb.data.take(6).length,
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
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 110),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          pb.data[index]['place name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: titleTextStyle,
                                        ),
                                        Text(
                                          pb.data[index]['location'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: subtitleTextStyle,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 8, bottom: 20),
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
                                              pb.data[index]['loves']
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
                                              pb.data[index]['comments count']
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
                              tag: 'suggestion$index',
                              child: Container(
                                height: 120,
                                width: 120,
                                child:
                                    cachedImage(pb.data[index]['image-1'], 10),
                              ),
                            ))
                      ],
                    ),
                    onTap: () {
                      nextScreen(
                          context,
                          PlaceDetailsPage(
                            placeName: pb.data[index]['place name'],
                            location: pb.data[index]['location'],
                            description: pb.data[index]['description'],
                            timestamp: pb.data[index]['timestamp'],
                            lat: pb.data[index]['latitude'],
                            lng: pb.data[index]['longitude'],
                            images: [
                              pb.data[index]['image-1'],
                              pb.data[index]['image-2'],
                              pb.data[index]['image-3'],
                            ],
                            extraImages: pb.data[index]['extra-images'],
                            tag: 'suggestion$index',
                          ));
                    },
                  ))));
        },
      ),
    );
  }

  Widget afterSearchUI() {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    double w = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5),
        itemCount: pb.filteredData.length,
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
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 110),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          pb.filteredData[index]['place name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: titleTextStyle,
                                        ),
                                        Text(
                                          pb.filteredData[index]['location'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: subtitleTextStyle,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 8, bottom: 20),
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
                                              pb.filteredData[index]['loves']
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
                                              pb.filteredData[index]
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
                              tag: 'filtered$index',
                              child: Container(
                                height: 120,
                                width: 120,
                                child: cachedImage(
                                    pb.filteredData[index]['image-1'], 10),
                              ),
                            ))
                      ],
                    ),
                    onTap: () {
                      nextScreen(
                          context,
                          PlaceDetailsPage(
                            placeName: pb.filteredData[index]['place name'],
                            location: pb.filteredData[index]['location'],
                            description: pb.filteredData[index]['description'],
                            timestamp: pb.filteredData[index]['timestamp'],
                            lat: pb.filteredData[index]['latitude'],
                            lng: pb.filteredData[index]['longitude'],
                            images: [
                              pb.filteredData[index]['image-1'],
                              pb.filteredData[index]['image-2'],
                              pb.filteredData[index]['image-3']
                            ],
                            extraImages: pb.filteredData[index]['extra-images'],
                            tag: 'filtered$index',
                          ));
                    },
                  ))));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context);
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 24,
          ),

          // search bar

          Container(
            alignment: Alignment.center,
            height: 65,
            width: w,
            decoration: BoxDecoration(
                //color: Colors.white
                ),
            child: Form(
              key: formKey,
              child: TextFormField(
                autofocus: true,
                controller: textFieldCtrl,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search & Explore Places",
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500]),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_backspace,
                        color: Colors.grey[800],
                      ),
                      color: Colors.grey[800],
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey[800],
                      size: 25,
                    ),
                    onPressed: () {
                      setState(() {
                        textFieldCtrl.clear();
                      });
                    },
                  ),
                ),

                //keyboardType: TextInputType.datetime,

                validator: (value) {
                  if (value.length == 0) return ("Comments can't be empty!");

                  return value = null;
                },
                // onSaved: (String value) {},
                onChanged: (String value) {
                  pb.afterSearch(value);
                },
              ),
            ),
          ),

          Container(
            height: 1,
            child: Divider(
              color: Colors.grey,
            ),
          ),

          // suggestion text

          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5),
            child: Text(
              txt,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          ),

          //afterSearchUI()
          pb.filteredData.isEmpty ? beforeSearchUI() : afterSearchUI()
        ],
      ),
    );
  }
}
