import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:travel_hour/blocs/blog_bloc.dart';
import 'package:travel_hour/models/variables.dart';
import 'package:travel_hour/pages/blog_details.dart';
import 'package:travel_hour/utils/cached_image.dart';
import 'package:travel_hour/utils/loading_animation.dart';
import 'package:travel_hour/utils/next_screen.dart';


class BlogPage extends StatelessWidget {
  BlogPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BlogBloc bb = Provider.of<BlogBloc>(context );
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          
          brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(
            'Blog'
            
          ),
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton(
                child: Icon(LineIcons.sort, color: Colors.black),
                //initialValue: 'view',
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem>[
                    PopupMenuItem(
                      child: Text('Most Recent'),
                      value: 'recent',
                    ),
                    PopupMenuItem(
                      child: Text('Most Popular'),
                      value: 'popular',
                    )
                  ];
                },
                onSelected: (value) {
                  bb.afterPopSelection(value);
                }),
            SizedBox(
              width: 15,
            )
          ],
        ),
        
        body: bb.data.isEmpty ? LoadingWidgetBlog() :
        
        
        AnimationLimiter(
          child: ListView.separated(
            itemCount: bb.data.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 0,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Container(
                      height: 380,
                      child: InkWell(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 10, left: 15, right: 15, bottom: 5),
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
                                  tag: 'blog$index',
                                  child: Container(
                                    color: Colors.grey[300],
                                    height: 200,
                                    width: w,
                                    child: cachedImage(bb.data[index]['image url'], 10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 15, bottom: 5, right: 10),
                                  child: Text(
                                    bb.data[index]['title'],
                                    style: titleTextStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 15, right: 15),
                                  child: Container(
                                    height: 50,
                                    child: Text(
                                      bb.data[index]['description'],
                                      style: subtitleTextStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                 Container(
                                   padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            LineIcons.copyright,
                                            color: Colors.blueAccent,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              child: Text(
                                              bb.data[index]['source'].contains('www') 
                                              ? bb.data[index]['source'].replaceAll('https://www.', '').split('.').first 
                                              : bb.data[index]['source'].replaceAll('https://', '').split('.').first,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          
                                          Row(
                                            children: <Widget>[
                                              Icon(LineIcons.heart,
                                                  size: 20, color: Colors.grey),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                bb.data[index]['loves']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          
                                        ],
                                      ),
                                    ),
                                  
                                
                              ],
                            ),
                          ),
                          onTap: (){
                            nextScreen(context, BlogDetailsPage(
                              title: bb.data[index]['title'],
                              description: bb.data[index]['description'],
                              imageUrl: bb.data[index]['image url'],
                              date: bb.data[index]['date'],
                              loves: bb.data[index]['loves'],
                              source: bb.data[index]['source'],
                              timestamp: bb.data[index]['timestamp'],
                              tag: 'blog$index',
                              
                              
                              
                              ));
                          }
                          
                          
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
