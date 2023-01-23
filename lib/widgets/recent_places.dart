import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/recent_places_bloc.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/loading_animation.dart';
import 'package:travel_hour/utils/next_screen.dart';

class RecentPlaces extends StatelessWidget {
  RecentPlaces({Key key, this.category: 1}) : super(key: key);

  final int category;

  @override
  Widget build(BuildContext context) {
    final RecentPlacesBloc rpb = Provider.of<RecentPlacesBloc>(context);
    var rpbData =
        rpb.data.where((element) => element['category'] == category).toList();
    double w = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                'Recently Added',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.grey[800]),
              ),
              Spacer(),
              FlatButton(
                onPressed: () => nextScreen(
                    context, MorePlacesPage(title: 'Recently Added', category: category)),
                child: Text(
                  'view all >>',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 205,
          width: w,
          child: rpbData.isEmpty
              ? LoadingWidget1()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: rpbData.take(6).length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: InkWell(
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: 'recent$index',
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                width: w * 0.35,
                                child:
                                    cachedImage(rpbData[index]['image-1'], 10),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 15,
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13),
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
                                tag: 'recent$index',
                              ));
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
