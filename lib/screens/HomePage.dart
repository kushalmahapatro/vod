import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vod/controllers/HomePageControllers.dart';
import 'package:vod/sdk/api/GetAppHomeFeature.dart';
import 'package:vod/widgets/CircularLoader.dart';
import 'package:vod/utils/ColorSwatch.dart';
import 'package:vod/utils/MyBehaviour.dart';
import 'package:vod/utils/Utils.dart';
import 'package:vod/widgets/Carousel.dart';
import 'package:vod/widgets/ColorLoader.dart';
import 'package:vod/widgets/FeatureSection.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomePageListener {
  HomePageController controller;

  _HomePageState() {
    controller = HomePageController(listener: this);
    controller.callApi();
  }

  GetAppHomeFeatureModel homePageData;
  bool apiFetched = false;

  Scaffold scaffold;
  BuildContext _context;

  List <Color> loaderColors = [primaryColor];

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "Sapphire",
    style: new TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget buildBar(BuildContext context) {
      return new AppBar(
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: primaryColor,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                Utils.snackBar("Search", _context);
              },
            ),
          ]);
    }

    List bannerImages() {
      List image = new List();
      for (int i = 0; i < homePageData.homePageBannerModelList.length; i++) {
        image.add(NetworkImage(homePageData
            .homePageBannerModelList[i].image_path
            .toString()
            .trim()));
      }
      return image;
    }

    Future<ui.Image> _getImage(String url) {
      Completer<ui.Image> completer = new Completer<ui.Image>();
      new NetworkImage(url)
          .resolve(new ImageConfiguration())
          .addListener((ImageInfo info, bool _) => completer.complete(info.image));
      return completer.future;
    }

    Widget body = apiFetched
        ? new Container(
            child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
                itemCount: homePageData.homePageSectionModelList.length + 2,
                itemBuilder: (BuildContext ctxt, int index) {
                  if (index == 0) {
                    return new SizedBox(
                        height: 900 / (1600 / screenWidth),
                        child: new Carousel(
                          autoplay: true,
                          dotBgColor: Colors.transparent,
                          dotColor: Colors.white,
                          noRadiusForIndicator: true,
                          dotSize: 5,
                          isDynamic: true,
                          images: [
                            bannerImages(),
                          ],
                        ));
                  } else if (index == 1) {
                    return new Container(
                      height: 3,
                      color: primaryColor,
                    );
                  } else {
                    if (homePageData
                            .homePageSectionModelList[index - 2].section_type == "0") {
                      return new Container(
                        child: new FutureBuilder<ui.Image>(
                          future: _getImage(homePageData.homePageSectionModelList[index - 2].homeFeaturePageSectionDetailsModel[0].poster_url),
                            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data.width > snapshot.data.height){
                                  return new FeatureSection(
                                    section:
                                    homePageData.homePageSectionModelList[index - 2],
                                    isVertical: false,
                                    onButtonPress: () {
                                      Utils.snackBar(
                                          homePageData.homePageSectionModelList[index - 2]
                                              .section_id,
                                          _context);
                                    },
                                  );
                                }else{
                                  return new FeatureSection(
                                    section:
                                    homePageData.homePageSectionModelList[index - 2],
                                    isVertical: true,
                                    onButtonPress: () {
                                      Utils.snackBar(
                                          homePageData.homePageSectionModelList[index - 2]
                                              .section_id,
                                          _context);
                                    },
                                  );
                                }
                              }else{
                                return new Container();
                              }
                            },
                          ),
                      );
                    } else {
                      return new Container();
                    }
                  }
                }),
          ))
        : Container(
            child: Center(
              child: ColorLoaderPlain(colors: loaderColors,
              duration: Duration(milliseconds: 1200),)

              /*ColorLoader(
                color1: primaryColor,
                color2: Colors.white,
                color3: primaryColor,
              ),*/
            ),
          );
    ;

    scaffold = new Scaffold(
        appBar: buildBar(context),
        backgroundColor: Colors.black,
        body: Builder(builder: (BuildContext _buildContext) {
          _context = _buildContext;
          return body;
        }));

    return scaffold;
  }

  @override
  void onApiFailure({Failures failure}) {
    // TODO: implement onApiFailure
  }

  @override
  void onApiSuccess({GetAppHomeFeatureModel data}) {
    // TODO: implement onApiSuccess
    setState(() {
      homePageData = data;
      apiFetched = true;
    });
  }
}