import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geo/geo.dart' as geo;
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:travel_hour/models/colors.dart';
import 'package:travel_hour/models/config.dart';

class GuidePage extends StatefulWidget {
  final String timestamp;
  final double lat;
  final double lng;
  GuidePage({Key key, @required this.timestamp, this.lat, this.lng})
      : super(key: key);

  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> _markers = [];
  Map data = {};
  String distance = 'O km';

  int _polylineCount = 1;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  Future getData() async {
    await Firestore.instance
        .collection('places')
        .document(widget.timestamp)
        .collection('travel guide')
        .document(widget.timestamp)
        .get()
        .then((DocumentSnapshot snap) {
      setState(() {
        data = snap.data;
      });
    });
  }

  _addMarker() {
    List m = [
      Marker(
          markerId: MarkerId(data['startpoint name']),
          position: LatLng(data['startpoint lat'], data['startpoint lng']),
          infoWindow: InfoWindow(title: data['startpoint name'])),
      Marker(
        markerId: MarkerId(data['endpoint name']),
        position: LatLng(data['endpoint lat'], data['endpoint lng']),
        infoWindow: InfoWindow(title: data['endpoint name']),
      )
    ];
    setState(() {
      m.forEach((element) {
        _markers.add(element);
      });
    });
  }

  void computeDistance() {
    var p1 = geo.LatLng(data['startpoint lat'], data['startpoint lng']);
    var p2 = geo.LatLng(data['endpoint lat'], data['endpoint lng']);
    double _distance = geo.computeDistanceBetween(p1, p2) / 1000;
    setState(() {
      distance = '${_distance.toStringAsFixed(2)} km';
    });
  }

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  getPolyLineData() async {
    GoogleMapPolyline googleMapPolyline =
        new GoogleMapPolyline(apiKey: Config().mapAPIKey);
    List<LatLng> _coordinates =
        await googleMapPolyline.getCoordinatesWithLocation(
            origin: LatLng(data['startpoint lat'], data['startpoint lng']),
            destination: LatLng(data['endpoint lat'], data['endpoint lng']),
            mode: RouteMode.driving);

    addPolyline(_coordinates);
  }

  addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 10,
        onTap: () {});

    setState(() {
      polylines[id] = polyline;
      _polylineCount++;
    });
  }

  @override
  void initState() {
    super.initState();
    getData().then((data) {
      _addMarker();

      computeDistance();
      getPolyLineData();
    });
  }

  Widget panelUI() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Travel Guide",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: 'Poppins'),
            ),
          ],
        ),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                text: 'Estimated Cost = ',
                children: <TextSpan>[
              TextSpan(
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  text: data['price'])
            ])),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
                text: 'Distance = ',
                children: <TextSpan>[
              TextSpan(
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  text: distance)
            ])),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          height: 3,
          width: 170,
          decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(40)),
        ),
        Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Steps',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  height: 3,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(40)),
                ),
              ],
            )),
        Expanded(
          child: data.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  padding: EdgeInsets.only(bottom: 10),
                  itemCount: data['paths'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                  radius: 15,
                                  child: Text('${index + 1}'),
                                  backgroundColor: GuideColors().colors[index]),
                              Container(
                                height: 90,
                                width: 2,
                                color: Colors.black12,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          // CircleAvatar(child: Text('${index + 1}'),),
                          // SizedBox(width: 10,),
                          Container(
                            child: Expanded(
                              child: Text(
                                data['paths'][index],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                  },
                ),
        ),
      ],
    );
  }

  Widget panelBodyUI(h, w) {
    return Container(
      width: w,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.lng),
            zoom: 12,
            tilt: 45,
            bearing: 45),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(_markers),
        polylines: Set<Polyline>.of(polylines.values),
        compassEnabled: false,
        myLocationEnabled: false,
        zoomGesturesEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return new Scaffold(
        body: Stack(children: <Widget>[
      SlidingUpPanel(
          minHeight: 125,
          maxHeight: MediaQuery.of(context).size.height * 0.80,
          //parallaxEnabled: true,
          // parallaxOffset: 0.5,
          backdropEnabled: true,
          backdropOpacity: 0.2,
          backdropTapClosesPanel: true,
          isDraggable: true,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey[400], blurRadius: 4, offset: Offset(1, 0))
          ],
          padding: EdgeInsets.only(top: 15, left: 10, bottom: 0, right: 10),
          panel: panelUI(),
          body: panelBodyUI(h, w)),
      Positioned(
        top: 45,
        left: 10,
        child: Container(
          child: Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 10,
                            offset: Offset(3, 3))
                      ]),
                  child: Icon(Icons.keyboard_backspace),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 5,
              ),
              data.isEmpty
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 0.5)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 10, right: 15),
                        child: Text(
                          '${data['startpoint name']} - ${data['endpoint name']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      data.isEmpty
          ? Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container()
    ]));
  }
}
