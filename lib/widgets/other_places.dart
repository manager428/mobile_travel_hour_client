import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/recommanded_places_bloc.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/next_screen.dart';

class OtherPlaces extends StatelessWidget {
  OtherPlaces({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecommandedPlacesBloc rpb =
        Provider.of<RecommandedPlacesBloc>(context);
    double w = MediaQuery.of(context).size.width;
    var rpbData =
        rpb.data.where((element) => element['category'] == 1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('You May Also Like',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins')),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 20),
          height: 3,
          width: 130,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(40)),
        ),
        Container(
          height: 205,
          width: w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: rpbData.take(6).length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 10);
            },
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: 'other$index',
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10)),
                        height: 200,
                        width: w * 0.35,
                        child: cachedImage(rpbData[index]['image-1'], 10),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 15,
                      height: 35,
                      width: 80,
                      child: FlatButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        color: Colors.grey[600].withOpacity(0.5),
                        icon: Icon(
                          LineIcons.heart,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          rpbData[index]['loves'].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 10,
                      right: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(rpbData[index]['place name'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
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
                        tag: 'others$index',
                      ));
                },
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
