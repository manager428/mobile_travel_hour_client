import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travel_hour/pages/comments.dart';
import 'package:travel_hour/pages/nearby.dart';
import 'package:travel_hour/utils/next_screen.dart';
import 'package:maps_launcher/maps_launcher.dart';

Widget todo(context, timestamp, lat, lng, placeName) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('To Do',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins')),
      Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        height: 3,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(40)),
      ),
      Container(
        //color: Colors.brown,
        height: 330,
        //width: w,
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
                      'Directions',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              onTap: () {
                MapsLauncher.launchCoordinates(lat, lng, placeName);
              },
            ),
            InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
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
                                color: Colors.orangeAccent[400],
                                offset: Offset(5, 5),
                                blurRadius: 2)
                          ]),
                      child: Icon(
                        LineIcons.hotel,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Text(
                      'Nearby Lodging',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              onTap: () {
                nextScreen(
                    context,
                    NearbyPlacesPage(
                        lat: lat,
                        lng: lng,
                        placeName: placeName,
                        title: "Explore Nearby Lodging",
                        category: 2));
              },
            ),
            InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent,
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
                                color: Colors.pinkAccent[400],
                                offset: Offset(5, 5),
                                blurRadius: 2)
                          ]),
                      child: Icon(Icons.restaurant),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Text(
                      'Nearby Food',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              onTap: () {
                nextScreen(
                    context,
                    NearbyPlacesPage(
                        lat: lat,
                        lng: lng,
                        placeName: placeName,
                        title: "Explore Nearby Food",
                        category: 3));
              },
            ),
            InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.indigoAccent,
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
                                color: Colors.indigoAccent[400],
                                offset: Offset(5, 5),
                                blurRadius: 2)
                          ]),
                      child: Icon(
                        LineIcons.comments,
                        size: 30,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Text(
                      'User Reviews',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  )
                ],
              ),
              onTap: () {
                nextScreen(
                    context,
                    CommentsPage(
                      title: 'User Reviews',
                      timestamp: timestamp,
                    ));
              },
            ),
          ],
        ),
      ),
    ],
  );
}
