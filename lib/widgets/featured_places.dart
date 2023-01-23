import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/place_bloc.dart';

import 'package:travel_hour/models/variables.dart';
import 'package:travel_hour/pages/place_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/loading_animation.dart';
import 'package:travel_hour/utils/next_screen.dart';

class Featured extends StatefulWidget {
  final int category;
  Featured({Key key, this.category}) : super(key: key);

  _FeaturedState createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  _FeaturedState();
  int listIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PlaceBloc pb = Provider.of<PlaceBloc>(context, listen: false);
    var pbData = pb.data
        .where((element) => element['category'] == widget.category)
        .toList();
    print(listIndex);
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, top: 10, bottom: 15),
          child: Text(
            ' Featured Places',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.grey[800]),
          ),
        ),
        Container(
          height: 280,
          width: w,
          child: pbData.isEmpty
              ? LoadingWidget2()
              : PageView.builder(
                  controller: PageController(initialPage: 2),
                  scrollDirection: Axis.horizontal,
                  itemCount: pbData.length >= 5
                      ? pbData.take(5).length
                      : pbData.length,
                  onPageChanged: (index) {
                    setState(() {
                      listIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                        width: w,
                        child: InkWell(
                          child: Stack(
                            children: <Widget>[
                              Hero(
                                tag: 'featured$index',
                                child: Container(
                                  height: 230,
                                  width: w,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10)),
                                  child:
                                      cachedImage(pbData[index]['image-1'], 10),
                                ),
                              ),
                              Positioned(
                                height: 120,
                                width: w * 0.70,
                                left: w * 0.11,
                                bottom: 15,
                                child: Container(
                                  //margin: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey[200],
                                            offset: Offset(0, 2),
                                            blurRadius: 2)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            pbData[index]['place name'],
                                            style: textStyleFeaturedtitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            Expanded(
                                              child: Text(
                                                pbData[index]['location'],
                                                style: subtitleTextStyle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey[300],
                                          height: 20,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                LineIcons.heart,
                                                size: 18,
                                                color: Colors.orange,
                                              ),
                                              Text(
                                                pbData[index]['loves']
                                                    .toString(),
                                                style: textStylicon,
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Icon(
                                                LineIcons.comment_o,
                                                size: 18,
                                                color: Colors.orange,
                                              ),
                                              Text(
                                                pbData[index]['comments count']
                                                    .toString(),
                                                style: textStylicon,
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            nextScreen(
                                context,
                                PlaceDetailsPage(
                                  placeName: pbData[index]['place name'],
                                  location: pbData[index]['location'],
                                  description: pbData[index]['description'],
                                  timestamp: pbData[index]['timestamp'],
                                  lat: pbData[index]['latitude'],
                                  lng: pbData[index]['longitude'],
                                  images: [
                                    pbData[index]['image-1'],
                                    pbData[index]['image-2'],
                                    pbData[index]['image-3']
                                  ],
                                  extraImages: pbData[index]['extra-images'],
                                  tag: 'featured$index',
                                ));
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        Center(
          child: DotsIndicator(
            dotsCount:
                pbData.length == 0 ? 1 : pbData.length >= 5 ? 5 : pbData.length,
            position:
                listIndex > pbData.length - 1 ? 0.0 : listIndex.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
              spacing: EdgeInsets.only(left: 6),
              size: const Size.square(7.0),
              activeSize: const Size(25.0, 5.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        )
      ],
    );
  }
}
