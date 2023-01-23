import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/popular_places_bloc.dart';
import 'package:travel_hour/pages/more_places.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/loading_animation.dart';
import 'package:travel_hour/utils/next_screen.dart';

class PopularPlaces extends StatelessWidget {
  final int category;
  PopularPlaces({Key key, this.category: 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PopularPlacesBloc ppb = Provider.of<PopularPlacesBloc>(context);
    var ppbData =
        ppb.data.where((element) => element['category'] == category).toList();
    double w = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                'Popular Places',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.grey[800]),
              ),
              Spacer(),
              FlatButton(
                onPressed: () =>
                    nextScreen(context, MorePlacesPage(title: 'Popular', category: category)),
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
          child: ppbData.isEmpty
              ? LoadingWidget1()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ppbData.take(6).length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: InkWell(
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: 'Popular$index',
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10)),
                                height: 200,
                                width: w * 0.35,
                                child:
                                    cachedImage(ppbData[index]['image-1'], 10),
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
                                  ppbData[index]['loves'].toString(),
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
                                  Text(ppbData[index]['place name'],
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
                                placeName: ppbData[index]['place name'],
                                location: ppbData[index]['location'],
                                description: ppbData[index]['description'],
                                timestamp: ppbData[index]['timestamp'],
                                lat: ppbData[index]['latitude'],
                                lng: ppbData[index]['longitude'],
                                images: [
                                  ppbData[index]['image-1'],
                                  ppbData[index]['image-2'],
                                  ppbData[index]['image-3']
                                ],
                                extraImages: ppbData[index]['extra-images'],
                                tag: 'popular$index',
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
