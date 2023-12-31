import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vod/screens/PlayerPage.dart';
import 'package:vod/sdk/api/GetAppHomeFeature.dart';
import 'package:vod/utils/ColorSwatch.dart';
import 'package:vod/utils/MyBehaviour.dart';
import 'package:vod/utils/Utils.dart';
import 'package:vod/widgets/DescriptionTextWidget.dart';
import 'package:vod/widgets/Episodes.dart';
import 'package:vod/widgets/Rating.dart';

class MovieDetailsPage extends StatefulWidget {
  final HomeFeaturePageSectionDetailsModel contentDetails;
  final int heroIndex;

  MovieDetailsPage({Key key, @required this.contentDetails, this.heroIndex}) : super(key: key);
//  MovieDetailsPage(this.contentDetails);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  Scaffold scaffold;
  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    String story =
        "A short story is a piece of prose fiction that typically can be read in one sitting and focuses on a self-contained incident or series of linked incidents, with the intent of evoking a single effect or mood, however there are many exceptions to this.";
    String cast =
        "Cast: Mouni Roy, Nikita Dutta, Nikita Dutta, Vineet Kumar Singh, Amit Sadh, Kunal Kapoor, Farhan Akhtar, shay Kumar";
    String director = "Director: Reema Kagti";

    double screenHeight = MediaQuery.of(context).size.height;

    bool multiPart = false;
    if (widget.contentDetails.contentTypesId == "3") {
      multiPart = true;
    } else if (widget.contentDetails.contentTypesId == "1" ||
        widget.contentDetails.contentTypesId == "2" ||
        widget.contentDetails.contentTypesId == "4") {
      multiPart = false;
    }

    Widget backgroundWidget() {
      return Hero(
        tag: widget.contentDetails.permalink+"-$widget.heroIndex",
        child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(this.widget.contentDetails.posterUrl.toString().trim()),
                fit: BoxFit.cover)),
      ));
    }

    Widget gradient() {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          decoration: BoxDecoration(
            color: appbackgroundColor.withOpacity(0.1),
          ),
        ),
      );
    }

    Widget gr() {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            // 10% of the width, so there are ten blinds.
            colors: [
              Colors.transparent,
              appbackgroundColor,
            ],
            // transparent to black
          ),
        ),
      );
    }

    Widget logoWidget() {
      return Center(
          child: Container(
              margin: EdgeInsets.only(bottom: 40.0),
              child: InkWell(
                child: Icon(Icons.play_circle_outline,
                    color: Colors.white, size: 60.0),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (c) => new Player(
                                contentDetails: widget.contentDetails,
                              )));
//                  Utils.snackBar("Play Video", _scaffoldContext);
                },
              )));
    }

    Widget column1() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "2016  ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          Text(
            "|  1h 43m  ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          Text(
            "|  PG-13",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ],
      );
    }

    Widget column2() {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        StarRating(
          starCount: 5,
          rating: 9 / 2,
          color: primaryColor,
          size: 12.0,
          borderColor: primaryColor,
        ),
      ]);
    }

    Widget column3() {
      return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              "2 Seasons",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            )),
      ]);
    }

    Widget row1() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          column1(),
          multiPart ? column3() : Container(),
          column2(),
        ],
      );
    }

    Widget row2() {
      return Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.title,
              color: Colors.white,
              size: 30.0,
            ),
            Text(
              "Watch trailer",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );
    }

    Widget row3() {
      return Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.favorite,
                color: primaryColor,
                size: 30.0,
              ),
              Text(
                "Favourite",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ],
          ));
    }

    Widget layout() {
      return Padding(
          padding: EdgeInsets.only(top: 10, bottom: 50.0, left: 20.0),
          child: Row(
            children: <Widget>[
              row1(),
              Spacer(),
              row2(),
              row3(),
            ],
          ));
    }

    Widget contentDetails() {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20.0),
                    child: Text(
                      "Movie",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 20.0),
                    child: Text(
                      widget.contentDetails.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w900),
                    )),
                layout(),
              ],
            )),
        alignment: Alignment.bottomLeft,
      );
    }

    Widget reviews() {
      return ListView.builder(
          itemCount: 7,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: StarRating(
                            color: primaryColor,
                            borderColor: primaryColor,
                            size: 17.0,
                            starCount: 5,
                            rating: 1 + (index / 2))),
                    Text(
                      "This is the best episode I ever watched of this season and I am waiting to watch more of this.",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 14.0),
                    )
                  ],
                ));
          });
    }

    Widget cd() {
      return ScrollConfiguration(
          behavior: MyBehavior(),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Wrap(runSpacing: 20.0, children: <Widget>[
                  Text("Story Line",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900)),
                  new DescriptionTextWidget(
                      text: story,
                      textStyle: new TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      )),
                  Text("Cast and Crew Details",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900)),
                  Text(
                    cast,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.grey,
                      fontSize: 13.0,
                    ),
                  ),
                  Text(director,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        color: Colors.grey,
                        fontSize: 13.0,
                      ))
                ]),
              )
            ],
          ));
    }

    Widget body = DefaultTabController(
        length: multiPart ? 3 : 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.black,
                  brightness: Brightness.dark,
                  leading: BackButton(color: Colors.white),
                  expandedHeight: screenHeight / 2.2,
                  forceElevated: innerBoxIsScrolled,
                  title: innerBoxIsScrolled
                      ? Text(
                          widget.contentDetails.name,
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(""),
                  pinned: true,
                  bottom: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: multiPart
                        ? [
                            Tab(text: "Info"),
                            Tab(text: "Episodes"),
                            Tab(text: "Review"),
                          ]
                        : [
                            Tab(text: "Info"),
                            Tab(text: "Review"),
                          ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          backgroundWidget(),
                          gradient(),
                          gr(),
                          multiPart ? new Container() : logoWidget(),
                          contentDetails()
                        ],
                      )),
                ),
              ];
            },
            body: TabBarView(
                children: multiPart
                    ? [cd(), ExpandableList(), reviews()]
                    : [cd(), reviews()])));

    scaffold = new Scaffold(
      backgroundColor: appbackgroundColor,
      body: Builder(builder: (BuildContext _context) {
        _scaffoldContext = _context;
        return body;
      }),
    );
    return scaffold;
  }
}

class ExpandableList extends StatelessWidget {
  final list =
      new List.generate(13, (i) => i + 1 >= 10 ? "E${i + 1}" : "E0${i + 1}");

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, i) => ExpansionTile(
            initiallyExpanded: i == 0 ? true : false,
            title: new Text(
              "Season ${i + 1}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            children: list
                .map((val) => new ListTile(
                      title: Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: VodEpisodes(
                            isVertical: false,
                            image: NetworkImage(
                                "https://static.posters.cz/image/750/posters/the-avengers-age-of-ultron-team-i27856.jpg"),
                            duration: "45 mins",
                            episodeName: "The New Episode",
                            seasonName: i + 1 >= 10
                                ? "S" + (i + 1).toString() + " : " + val
                                : "S0" + (i + 1).toString() + ": " + val,
                            showDownload: true,
                          )),
                    ))
                .toList(),
          ),
      itemCount: 2,
    );
  }
}
