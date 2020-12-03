import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kiakia_rider/change_notifier.dart';
import 'package:kiakia_rider/profile/cloud_storage.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final Map details;
  final String photoURL;
  Profile({this.photoURL, this.details});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = 'Niza';
  @override
  Widget build(BuildContext context) {
    bool showLoader = Provider.of<AllChangeNotifiers>(context).showProfilePicChangeLoader;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, viewPort) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: viewPort.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: widget.details == null
                          ? Container(
                        color: Color.fromRGBO(77, 172, 246, 1),
                      )
                          : Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            overflow: Overflow.visible,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                child:
                                widget.photoURL == null ||
                                    widget.photoURL ==
                                        ''
                                    ? Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 55,
                                  ),
                                )
                                    : InkWell(
                                  splashColor: Colors
                                      .transparent,
                                  onTap: widget.photoURL !=
                                      null &&
                                      widget.photoURL !=
                                          ''
                                      ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShowProfilePic(widget.photoURL)));
                                  }
                                      : null,
                                  child: Hero(
                                      tag: 'image',
                                      child:
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            60),
                                        child:
                                        CachedNetworkImage(
                                            imageUrl: widget
                                                .photoURL,
                                            placeholder: (context, url) => CircleAvatar(
                                                radius:
                                                60,
                                                backgroundColor: Colors.blue[
                                                100],
                                                child:
                                                CircularProgressIndicator()),
                                            errorWidget: (context,
                                                url,
                                                error) {
                                              return CircleAvatar(
                                                radius: 60,
                                                child: Icon(Icons.person, size: 60),
                                              );
                                            }),
                                      )),
                                ),
                                backgroundColor:
                                widget.photoURL == null ||
                                    widget.photoURL ==
                                        ''
                                    ? Colors.blue[100]
                                    : Colors.white,
                              ),
                              if (showLoader == false)
                                Positioned(
                                  bottom: -5,
                                  right: -20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[300],
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons
                                              .photo_camera_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          PickProfileImage(
                                              _scaffoldKey,
                                              context)
                                              .pickImage();
                                        }),
                                  ),
                                ),
                              if (showLoader)
                                CircularProgressIndicator()
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ShowProfilePic extends StatefulWidget {
  final String photoURL;
  ShowProfilePic(this.photoURL);
  @override
  _ShowProfilePicState createState() => _ShowProfilePicState();
}

class _ShowProfilePicState extends State<ShowProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Profile Photo',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Hero(
          tag: 'image',

          child: CachedNetworkImage(
              imageUrl: widget.photoURL,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.person)),
        ),
      ),
    );
  }
}

