import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Niza/Flutter_Projects/kiakia_rider/lib/profile/profile.dart';

class MyDrawer extends StatefulWidget {
  final String photoURL;
  MyDrawer({this.photoURL});
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Map<String, dynamic> rider = {};
  String name = 'Niza';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Color(0xffFDFEFF),
            padding: EdgeInsets.all(10),
            child: rider == null
                ? Container(
                    height: 150,
                    color: Color(
                      0xffFDFEFF,
                    ),
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            widget.photoURL == null || widget.photoURL == ''
                                ? Colors.white
                                : Color.fromRGBO(77, 172, 246, 1),
                        child: widget.photoURL == null || widget.photoURL == ''
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    Color.fromRGBO(77, 172, 246, 0.7),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 55,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: widget.photoURL,
                                  placeholder: (context, url) => CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        Color.fromRGBO(77, 172, 246, 0.7),
                                    child: Icon(
                                      Icons.person,
                                      size: 55,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(details: {'name': 'man',})));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(57, 138, 239, 0.2),
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'view profile',
                            style: TextStyle(
                              color: Color(0xff398AEF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 30),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(70, 10, 5, 10),
              child: Text('Dispatch History'),
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(70, 10, 5, 10),
              child: Text('FAQ'),
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(70, 10, 5, 10),
              child: Text('About'),
            ),
          ),
          SizedBox(height: 30),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(70, 10, 5, 10),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
