import 'package:WSHCRD/firebase_services/customer_controller.dart';
import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/screens/customer/request/accept_bid.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/widget/request_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:timeago/timeago.dart' as timeago;

class SeeBidsViewArguments {
  final Request request;

  SeeBidsViewArguments(this.request);
}

class SeeBidsView extends StatefulWidget {
  static const routeName = "/see-bids-view";
  final Request request;

  const SeeBidsView({Key key, this.request}) : super(key: key);

  @override
  _SeeBidsViewState createState() => _SeeBidsViewState();
}

class _SeeBidsViewState extends State<SeeBidsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MY BIDS',
          style: TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RequestCard(request: widget.request),
          ),
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
                "ALL BIDS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: CustomerController.getAllBidsOn(request:widget.request.requestId),
              builder: (context,snapshot){
                if(snapshot.hasData
                    && snapshot.data != null
                    && snapshot.data.documents.isNotEmpty
                ){
                  var docs = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context,index){
                      final bid = Bid.fromJson(docs[index].data);
                      return BidCard(
                        bid: bid,
                        onPressedAccept: (){
                          acceptBid(bid);
                        },
                      );
                    },
                  );
                }else{
                  return Center(
                    child: Text("No Bids Found"),
                  );
                }
              },
            )
          )
        ],
      ),
    );
  }

  void acceptBid(Bid bid) async{
    showLoadingScreen();
    await CustomerController.acceptBid(bid);
    closeLoadingScreen();
    Navigator.of(context).pushNamed(
      AcceptBidView.routeName,
      arguments: AcceptBidViewArguments(bid),
    );
  }

}

class BidCard extends StatelessWidget {
  final Bid bid;
  final Function onPressedAccept;

  const BidCard({Key key, this.bid, this.onPressedAccept}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(
          color: Colors.black12,
          offset: Offset(0,6),
          blurRadius: 15,
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/store.png",
                      height: 35,
                      width: 35,
                    ),
                    SizedBox(width: 8,),
                    Text(
                      bid.storeName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                buildTimeAgo(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: getDistanceIndicator(bid.request, bid.storeLocation)),
                Expanded(child: buildDeliveryType()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 16,
              bottom: 8,
            ),
            child: Text(
              "₹ ${bid.amount}/-",
              // "₹ ${widget.bid.amount}/-",
              style: TextStyle(
                color: Color(0xFF3642E9),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Divider(color: Colors.black,thickness: 3,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onPressedAccept,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ACCEPT THIS",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Image.asset(
                    "assets/icons/arrow_forward.png",
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8,)
        ],
      ),
    );
  }

  Widget buildTimeAgo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: 16,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          getTimeAgo(),
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  String getTimeAgo() {
    DateTime now = DateTime.now().toUtc();
    var creationDate = now.subtract(Duration(
        milliseconds: now
            .difference(DateTime.fromMillisecondsSinceEpoch(
            bid.biddenAt.millisecondsSinceEpoch ?? 0,
            isUtc: true))
            .inMilliseconds));
    return timeago.format(creationDate);
  }


  Widget getDistanceIndicator(Request request, GeoPoint bidLocation) {
    double distance = GeoFirePoint.distanceBetween(
        to: request.location.coords,
        from: Coordinates(
            bidLocation.latitude, bidLocation.longitude)) *
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
    return Row(
      children: <Widget>[
        Icon(Icons.location_on),
        SizedBox(
          width: 10,
        ),
        Text(
          distanceText,
          style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDeliveryType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/icons/delivery_type.png",
          height: 16,
          width: 16,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          bid.type == "home_delivery"?"Home Delivery":"Store Pickup",
          style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
        ),
      ],
    );

  }

}

