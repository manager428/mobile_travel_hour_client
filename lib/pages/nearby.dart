import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/nearby_places_bloc.dart';

import 'package:travel_hour/models/variables.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/next_screen.dart';

class NearbyPlacesPage extends StatefulWidget {
  final String placeName, title;
  final double lat, lng;
  final int category;
  NearbyPlacesPage(
      {Key key,
      @required this.placeName,
      this.category,
      this.lat,
      this.lng,
      this.title})
      : super(key: key);

  @override
  _NearbyPlacesPageState createState() => _NearbyPlacesPageState();
}

class _NearbyPlacesPageState extends State<NearbyPlacesPage> {
  String title;

  List data = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      final NearByPlacesBloc npb = Provider.of<NearByPlacesBloc>(context);
      npb.getData(widget.lat, widget.lng).then((value) => {
            setState(() {
              data = npb.data
                  .where((element) => (element['category'] == widget.category &&
                      element['place name'] != widget.placeName))
                  .toList();
              print(data);
            })
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(widget.title,
              style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 20,
                  fontWeight: FontWeight.w700)),
        ),
        body: Container(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 0),
                    height: 310,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 10,
                              offset: Offset(3, 3))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: '$title$index',
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(),
                            child: cachedImage(data[index]['image-1'], 10),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data[index]['place name'],
                                style: titleTextStyle,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    data[index]['location'],
                                    style: subtitleTextStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.favorite,
                                      size: 18, color: Colors.grey),
                                  Text(
                                    data[index]['loves'].toString(),
                                    style: textStylicon,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Icon(Icons.comment,
                                      size: 18, color: Colors.grey),
                                  Text(
                                    data[index]['comments count'].toString(),
                                    style: textStylicon,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                onTap: () {
                  nextScreenReplace(
                      context,
                      PlaceDetailsPage(
                        placeName: data[index]['place name'],
                        location: data[index]['location'],
                        description: data[index]['description'],
                        timestamp: data[index]['timestamp'],
                        lat: data[index]['latitude'],
                        lng: data[index]['longitude'],
                        images: [
                          data[index]['image-1'],
                          data[index]['image-2'],
                          data[index]['image-3']
                        ],
                        extraImages: data[index]['extra-images'],
                        tag: '$title$index',
                      ));
                },
              );
            },
          ),
        ));
  }
}
