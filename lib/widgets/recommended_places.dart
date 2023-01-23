import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/recommanded_places_bloc.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/loading_animation.dart';
import 'package:travel_hour/utils/next_screen.dart';

class RecommendedPlaces extends StatelessWidget {
  RecommendedPlaces({Key key, this.category: 1}) : super(key: key);

  final int category;

  @override
  Widget build(BuildContext context) {
    final RecommandedPlacesBloc rpb =
        Provider.of<RecommandedPlacesBloc>(context);
    var rpbData =
        rpb.data.where((element) => element['category'] == category).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 20, bottom: 0),
          child: Text(
            'Recommended Places',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.grey[800]),
          ),
        ),
        rpbData.isEmpty
            ? Container(height: 300, child: LoadingWidget1())
            : ListView.builder(
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: rpbData.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'recommended$index',
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: 15, left: 15, right: 15, bottom: 0),
                              height: 230,
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
                              child:
                                  cachedImage(rpbData[index]['image-1'], 10)),
                        ),
                        Positioned(
                          right: 30,
                          top: 30,
                          height: 35,
                          width: 80,
                          child: FlatButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            color: Colors.grey[600].withOpacity(0.5),
                            icon: Icon(
                              LineIcons.heart,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              rpbData[index]['loves'].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                  color: Colors.grey[900].withOpacity(0.6),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    rpbData[index]['place name'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on,
                                          size: 16, color: Colors.grey[400]),
                                      Expanded(
                                        child: Text(
                                          rpbData[index]['location'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                    onTap: () {
                      nextScreen(
                          context,
                          PlaceDetailsPage(
                            placeName: rpbData[index]['place name'],
                            location: rpbData[index]['location'],
                            description: rpbData[index]['description'],
                            timestamp: rpbData[index]['timestamp'],
                            lat: rpbData[index]['latitude'],
                            lng: rpbData[index]['longitude'],
                            images: [
                              rpbData[index]['image-1'],
                              rpbData[index]['image-2'],
                              rpbData[index]['image-3']
                            ],
                            extraImages: rpbData[index]['extra-images'],
                            tag: 'recommended$index',
                          ));
                    },
                  );
                },
              ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
