import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidgetBlog extends StatelessWidget {
  const LoadingWidgetBlog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
            baseColor: Colors.black87,
            highlightColor: Colors.white54,
            child: Stack(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
                  height: 340,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.black26,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 30,
                  top: 30,
                  height: 30,
                  width: 100,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class LoadingWidget1 extends StatelessWidget {
  const LoadingWidget1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(right: 15),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.black87,
          highlightColor: Colors.white54,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                      height: 200,
                  width: MediaQuery.of(context).size.width * 0.35,
                ),
                Positioned(
                    right: 10,
                    top: 15,
                    height: 35,
                    width: 80,
                    child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(25)),
                  ),),
                Positioned(
                  bottom: 30, 
                  left: 10, 
                  right: 5, 
                  child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 5, right: 0),
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),  
                      SizedBox(height: 10,),
                      Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 5, right: 0),
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),            
                                    
                                  ],
                                ),)
              ],
            ),
          ),
        );
      },
    );
  }
}




class LoadingWidget2 extends StatelessWidget {
  const LoadingWidget2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.black87,
          highlightColor: Colors.white54,
          child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, ),
                child: SizedBox(
                  height: 280,
                  width: w,
                  child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: 'featured$index',
                          child: Container(
                            height: 230,
                            width: w,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            
                          ),
                        ),
                        Positioned(
                          height: 120,
                          width: w * 0.70,
                          left: w * 0.11,
                          bottom: 15,
                          child: Container(
                            
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                                
                                ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                   Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 5, right: 0),
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),  
                      SizedBox(height: 10,),
                                   Container(
                        height: 5,
                        margin: EdgeInsets.only(left: 5, right: 0),
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(25)),
                      ),  
                      SizedBox(height: 20,),
                                  
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black26,
                            ),
                            SizedBox(width: 20,),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black26,
                            )
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
                    
                     
                    
                  
                ),
              )
        );
      },
    );
  }
}