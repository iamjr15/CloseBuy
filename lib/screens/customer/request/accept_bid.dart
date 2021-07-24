import 'package:WSHCRD/firebase_services/customer_controller.dart';
import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class AcceptBidViewArguments {
  final Bid bid;

  AcceptBidViewArguments(this.bid);
}

class AcceptBidView extends StatefulWidget {
  final Bid bid;
  static const routeName = "/accept-bid-view";

  const AcceptBidView({Key key, this.bid}) : super(key: key);

  @override
  _AcceptBidViewState createState() => _AcceptBidViewState();
}

class _AcceptBidViewState extends State<AcceptBidView> {
  Bid bid;
  @override
  void initState() {
    this.bid = widget.bid;
    listenForBidUpdated();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'ACCEPT BID',
            style: TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  )),
              child: Center(
                child: Text(
                  "BID CONFIRMED",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/icons/store.png",
                  height: 23,
                  width: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  bid.storeName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getDistanceIndicator(
                    bid.request, bid.storeLocation),
                buildDeliveryType(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                left: 16,
                bottom: 8,
              ),
              child: Text(
                "₹ ${bid.amount}/-",
                // "₹ ${widget.bid.amount}/-",
                style: TextStyle(
                  color: Color(0xFF3642E9),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "amount payable on delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              width: 150,
              color: Color(0xff66FD96),
              margin: EdgeInsets.only(right: 5),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CALL",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
            Container(
              height: 47,
              margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
              child: TextButton(
                onPressed: bid.status == "owner_marked_as_complete"?markAsComplete:null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "MARK AS COMPLETE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                    return BorderSide(
                      color: Colors.black,
                      width: 3,
                    );
                  }),
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5));
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled))
                        return Color(0xFF0062F5).withOpacity(0.5);
                      else
                        return Color(0xFF0062F5);
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget getDistanceIndicator(Request request, GeoPoint bidLocation) {
    double distance = GeoFirePoint.distanceBetween(
            to: request.location.coords,
            from: Coordinates(bidLocation.latitude, bidLocation.longitude)) *
        1000;
    String distanceText;
    if (distance > 1000) {
      int newDistance = distance ~/ 1000;
      distanceText =
          '$newDistance ' + (newDistance > 1 ? 'kms away' : 'km away');
    } else {
      distanceText = '${distance.toInt()} ' +
          (distance > 1 ? 'meters away' : 'meter away');
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.location_on,
          size: 25,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          distanceText,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDeliveryType() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/icons/delivery_type.png",
          height: 25,
          width: 25,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          bid.type == "home_delivery" ? "Home Delivery" : "Store Pickup",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void markAsComplete() {
    CustomerController.markAsComplete(bid);
  }

  void listenForBidUpdated() {
    CustomerController.getBid(bid).listen((event) {
      if(event.exists && event.data.isNotEmpty) {
        setState(() {
          bid = Bid.fromJson(event.data);
        });
      }
    });
  }
}
