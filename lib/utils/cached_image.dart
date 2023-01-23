


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

Widget cachedImage(String imageUrl, double radius) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            shape: BoxShape.rectangle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Icon(
          LineIcons.photo,
          size: 30,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }