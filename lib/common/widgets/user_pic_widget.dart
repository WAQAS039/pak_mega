import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pak_mega_mcqs/common/utils/dimensions.dart';

class UserPicWidget extends StatelessWidget {
  final String imageUrl;
  final String imageType;
  final double? radius;
  const UserPicWidget({Key? key,required this.imageUrl,this.radius = 20,required this.imageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25)
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: imageType != "asset" ? CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ): Image.asset(imageUrl))
    );
  }
}


class UserPicWidgetForOffline extends StatelessWidget {
  final double? radius;
  const UserPicWidgetForOffline({Key? key,this.radius = 20}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: radius,
        child: Icon(Icons.person,size: Dimensions.height50,),
      ),
    );
  }
}

