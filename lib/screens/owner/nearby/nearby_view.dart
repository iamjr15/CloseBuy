import 'package:WSHCRD/common/category_label.dart';
import 'package:WSHCRD/common/circle.dart';
import 'package:WSHCRD/common/priority.dart';
import 'package:WSHCRD/common/selected_circle.dart';
import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/owner.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/router.dart';
import 'package:WSHCRD/screens/owner/add_bid/add_bid_view.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:WSHCRD/widget/request_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart' as flutterLoc;
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class OwnerNearByView extends StatefulWidget {
  static const routeName = 'OwnerNearByView';

  @override
  _OwnerNearByViewState createState() => _OwnerNearByViewState();
}

class _OwnerNearByViewState extends State<OwnerNearByView>
    with TickerProviderStateMixin {
  int selectedRadius = 0;
  String category;
  List<Widget> cardList = [Container()];
  double height, width;
  Owner owner;
  flutterLoc.LocationData ownerLocation;

  @override
  void initState() {
    selectedRadius = SessionController.getSelectedRadiusIndex();
    owner = SessionController.getOwnerInfoFromLocal();
    ownerLocation = flutterLoc.LocationData.fromMap({
      'latitude': owner.location.latitude,
      'longitude': owner.location.longitude
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Near By'.toUpperCase(),
          style: TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                    MediaQuery.of(context).size.width * 2.5 / 16,
                  ),
                  child: Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                      MediaQuery.of(context).size.width * 1 / 16),
                  height: 50,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: selectedCircle,
                          onTap: () {
                            setState(() {
                              selectedRadius = 0;
                              SessionController.setSelectedRadiusIndex(
                                  selectedRadius);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: selectedRadius > 0
                              ? selectedCircle
                              : circle,
                          onTap: () {
                            setState(() {
                              selectedRadius = 1;
                              SessionController.setSelectedRadiusIndex(
                                  selectedRadius);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: selectedRadius > 1
                              ? selectedCircle
                              : circle,
                          onTap: () {
                            setState(() {
                              selectedRadius = 2;
                              SessionController.setSelectedRadiusIndex(
                                  selectedRadius);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: selectedRadius > 2
                              ? selectedCircle
                              : circle,
                          onTap: () {
                            setState(() {
                              selectedRadius = 3;
                              SessionController.setSelectedRadiusIndex(
                                  selectedRadius);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              kRadiusListText[selectedRadius],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
                stream: OwnerController.getAllActiveNearByRequestsForRadius(
                    kRadiusList[selectedRadius], ownerLocation),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Request> requests = snapshot.data
                        .map((e) => Request.fromJson(e.data))
                        .toList()
                        .where(filterRequests).toList();
                    if (requests.length > 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Active requests near by',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                  Text('${requests.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: Hexcolor('ff77bfff')),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: RequestCard(
                                    request: requests[index],
                                    onPressedCall: (){},
                                    onPressedBid: (){
                                      Navigator.pushNamed(context, AddBidView.routeName,
                                          arguments: AddBidViewArguments(requests[index]));
                                    },
                                    currentLocation: ownerLocation,
                                    color: kColorSlabs[index % kColorSlabs.length],
                                  ),
                                );
                              },
                              itemCount: requests.length,
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container(
                        child: Text('No Requests found'),
                      );
                    }
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildView(){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Near By'.toUpperCase(),
            style: TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 2.5 / 16,
                        ),
                        child: Divider(
                          color: Colors.black,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 1 / 16),
                        height: 50,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: selectedCircle,
                                onTap: () {
                                  setState(() {
                                    selectedRadius = 0;
                                    SessionController.setSelectedRadiusIndex(
                                        selectedRadius);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: selectedRadius > 0
                                    ? selectedCircle
                                    : circle,
                                onTap: () {
                                  setState(() {
                                    selectedRadius = 1;
                                    SessionController.setSelectedRadiusIndex(
                                        selectedRadius);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: selectedRadius > 1
                                    ? selectedCircle
                                    : circle,
                                onTap: () {
                                  setState(() {
                                    selectedRadius = 2;
                                    SessionController.setSelectedRadiusIndex(
                                        selectedRadius);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                child: selectedRadius > 2
                                    ? selectedCircle
                                    : circle,
                                onTap: () {
                                  setState(() {
                                    selectedRadius = 3;
                                    SessionController.setSelectedRadiusIndex(
                                        selectedRadius);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    kRadiusListText[selectedRadius],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            StreamBuilder<List<DocumentSnapshot>>(
                stream: OwnerController.getAllActiveNearByRequestsForRadius(
                    kRadiusList[selectedRadius], ownerLocation),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Request> requests = snapshot.data
                        .map((e) => Request.fromJson(e.data))
                        .toList()
                        .where(filterRequests).toList();
                    if (requests.length > 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 8),
                          //   child: Container(
                          //     padding: const EdgeInsets.all(16.0),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: <Widget>[
                          //         Text('Active requests near by',
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .subtitle1
                          //                 .copyWith(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.bold)),
                          //         Text('${requests.length}',
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .headline5
                          //                 .copyWith(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.bold)),
                          //       ],
                          //     ),
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(5),
                          //         ),
                          //         color: Hexcolor('ff77bfff')),
                          //   ),
                          // ),
                          Expanded(
                            child: Container(color: Colors.red,),
                            // child: ListView.builder(
                            //   itemBuilder: (context,index){
                            //     return Container(
                            //       height: 200,
                            //       width: double.infinity,
                            //       color: kColorSlabs[index % kColorSlabs.length],
                            //     );
                            //     // return RequestCard(
                            //     //   request: requests[index],
                            //     //   onPressedCall: (){},
                            //     //   onPressedBid: (){
                            //     //     Navigator.pushNamed(context, AddBidView.routeName,
                            //     //         arguments: AddBidViewArguments(requests[index]));
                            //     //   },
                            //     //   currentLocation: ownerLocation,
                            //     //   color: kColorSlabs[index % kColorSlabs.length],
                            //     // );
                            //   },
                            //   itemCount: 5,
                            // ),
                          )
                          // requests.length ==
                          //         1 // if only one request then show one card else show the stack
                          //     ? Container(
                          //         height:
                          //             MediaQuery.of(context).size.height * 0.63,
                          //         padding: EdgeInsets.only(top: 16),
                          //         child:
                          //             StackView(requests[0], 0, ownerLocation),
                          //       )
                          //     : Container(
                          //         height:
                          //             MediaQuery.of(context).size.height * 0.65,
                          //         child: TinderSwapCard(
                          //           animDuration: 200,
                          //           orientation: AmassOrientation.BOTTOM,
                          //           totalNum: requests.length,
                          //           stackNum: requests.length,
                          //           swipeEdge: 4.0,
                          //           maxWidth: MediaQuery.of(context).size.width,
                          //           maxHeight:
                          //               MediaQuery.of(context).size.height *
                          //                   0.60,
                          //           minWidth:
                          //               MediaQuery.of(context).size.width *
                          //                   0.95,
                          //           minHeight:
                          //               MediaQuery.of(context).size.height *
                          //                   0.59,
                          //           cardBuilder: (context, index) {
                          //             return StackView(requests[index], index,
                          //                 ownerLocation);
                          //           },
                          //           cardController: CardController(),
                          //           swipeUpdateCallback:
                          //               (DragUpdateDetails details,
                          //                   Alignment align) {
                          //             /// Get swiping card's alignment
                          //             if (align.x < 0) {
                          //               //Card is LEFT swiping
                          //             } else if (align.x > 0) {
                          //               //Card is RIGHT swiping
                          //             }
                          //           },
                          //           swipeCompleteCallback:
                          //               (CardSwipeOrientation orientation,
                          //                   int index) {
                          //             /// Get orientation & index of swiped card!
                          //           },
                          //         ),
                          //       ),
                        ],
                      );
                    } else {
                      return Container(
                        child: Text('No Requests found'),
                      );
                    }
                  } else {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
  /*
   get only those requests who are active and their category matches users category and
   visibility is valid as well.
   */
  getRelevantRequest(Request element, DateTime yesterdayTime) {
    return ((element.requestVisibility == Request.REQ_VISIBILITY_BOTH ||
            element.requestVisibility == Request.REQ_VISIBILITY_STORES_ONLY) &&
        (element.category == owner.category) &&
        element.creationDateInEpoc > yesterdayTime.millisecondsSinceEpoch);
  }

  bool filterRequests(Request request) {
    if(request.biddenBy != null){
      final ownerId = SessionController.getOwnerInfoFromLocal().ownerId;
      if(request.biddenBy.contains(ownerId)){
        return false;
      }
    }
    return true;//getRelevantRequest(request, getYesterdayTime());
  }
}

/*
Show how far the customers's requested location is
 */

getDistanceIndicator(Request request, flutterLoc.LocationData currentLocation) {
  double distance = GeoFirePoint.distanceBetween(
          to: request.location.coords,
          from: Coordinates(
              currentLocation.latitude, currentLocation.longitude)) *
      1000;
  String distanceText;
  if (distance > 1000) {
    int newDistance = distance ~/ 1000;
    distanceText = '$newDistance ' + (newDistance > 1 ? 'kms away' : 'km away');
  } else {
    distanceText =
        '${distance.toInt()} ' + (distance > 1 ? 'meters away' : 'meter away');
  }
  return Row(
    children: <Widget>[
      Icon(Icons.location_on),
      SizedBox(
        width: 10,
      ),
      Text(
        distanceText,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );
}

getItems(Request request) {
  List<Widget> items = [];
  if (request.type == Request.LIST) {
    int count = 1;
    for (String item in request.itemArray) {
      items.add(
        Text(
          '${count++}. $item',
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  } else {
    items.add(
      Text(
        request.itemParagraph,
        overflow: TextOverflow.clip,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.only(
      left: 32.0,
      bottom: 16.0,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    ),
  );
}

class StackView extends StatefulWidget {
  final Request request;
  final int index;
  final flutterLoc.LocationData ownerLocation;

  StackView(this.request, this.index, this.ownerLocation);

  @override
  _StackViewState createState() => _StackViewState();
}

class _StackViewState extends State<StackView> {
  DateTime creationDate;

  @override
  void initState() {
    DateTime now = DateTime.now().toUtc();
    creationDate = now.subtract(Duration(
        milliseconds: now
            .difference(DateTime.fromMillisecondsSinceEpoch(
                widget.request.creationDateInEpoc ?? 0,
                isUtc: true))
            .inMilliseconds));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: kColorSlabs[widget.index % kColorSlabs.length],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                getDistanceIndicator(widget.request, widget.ownerLocation),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        timeago.format(creationDate),
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Text(
                'I need help with following things:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            getItems(widget.request),
            Row(
              children: [
                PriorityWidget(
                  widget.request.priority,
                  readOnly: true,
                  request: widget.request,
                ),
                CategoryLabel(widget.request.category),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Color(0xff66FD96),
                    margin: EdgeInsets.only(left: 10, right: 5),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CALL",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        Container(
                          height: 15,
                          width: 15,
                          child: Image.asset(
                            'assets/icons/arrow_right.png',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AddBidView.routeName,
                          arguments: AddBidViewArguments(widget.request));
                    },
                    child: Container(
                      color: Color(0xff66FD96),
                      margin: EdgeInsets.only(left: 5, right: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bid",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/icons/arrow_right.png',
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
            // getCallButton(),
          ],
        ),
      ),
    );
  }

  getCallButton() {
    return FutureBuilder(
        future: OwnerController.getRequestOwnerID(widget.request.ownerId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          print("snapshot.data ${snapshot.data.documents[0]['phoneNumber']}");
          return GestureDetector(
            onTap: () {
              String phone = snapshot.data.documents[0]['phoneNumber'];
              launch("tel://$phone");
            },
            child: Container(
              color: Color(0xff66FD96),
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "CALL",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 75),
                  Container(
                    height: 15,
                    width: 15,
                    child: Image.asset(
                      'assets/icons/arrow_right.png',
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
