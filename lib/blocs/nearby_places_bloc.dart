import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NearByPlacesBloc extends ChangeNotifier {
  List _data = [];
  List get data => _data;
  set data(newData) => _data = newData;

  Future getData(lat, lng) async {
    QuerySnapshot snap =
        await Firestore.instance.collection('places').getDocuments();
    var x = snap.documents;
    _data.clear();
    x.forEach((f) {
      _data.add(f);
    });
    _data.sort((a, b) => compareNearby(a, b, lat, lng));
    // print(_data);
    // _data.forEach((f) {
    //   if (f['latitude'] != null && f['longitude'] != null) {
    //     print(calculateDistance(f['latitude'], f['longitude'], lat, lng).toString());
    //   }
    // });

    notifyListeners();
  }

  int compareNearby(a, b, orgLat, orgLng) {
    print(a);
    print(b);

    if (a['longitude'] == null ||
        b['longitude'] == null ||
        a['latitude'] == null ||
        b['latitude'] == null) {
      return 1;
    }
    var aLength = calculateDistance(a['latitude'], a['longitude'], orgLat, orgLng);
        // pow((a['latitude'] - orgLat), 2) + pow((a['longitude'] - orgLng), 2);
    var bLength = calculateDistance(b['latitude'], b['longitude'], orgLat, orgLng);
        // pow((b['latitude'] - orgLat), 2) + pow((b['longitude'] - orgLng), 2);

    return aLength.compareTo(bLength);
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}
