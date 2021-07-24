import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/widget/request_card.dart';
import 'package:flutter/material.dart';
class BidDetailsViewArguments{
  final Bid bid;

  BidDetailsViewArguments(this.bid);
}

class BidDetailsView extends StatefulWidget {
  final Bid bid;

  static const routeName = "/bid-details-view";

  const BidDetailsView({Key key, this.bid}) : super(key: key);

  @override
  _BidDetailsViewState createState() => _BidDetailsViewState();
}

class _BidDetailsViewState extends State<BidDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "MY BIDS",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            margin: EdgeInsets.only(top: 32,left: 50,right: 50),
            padding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                )
            ),
            child: Center(
              child: Text(
                "TASK DETAILS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:32,left: 8,right: 8),
            child: RequestCard(request: widget.bid.request),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
            ),
            child: Text(
              "₹ ${widget.bid.amount}/-",
              style: TextStyle(
                color: Color(0xFF3642E9),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              "amount payable on delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 150,
            color: Color(0xff66FD96),
            margin: EdgeInsets.only(top: 24),
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
              onPressed: widget.bid.status == "active"?markAsComplete:null,
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
      ),
    );
  }

  void markAsComplete() {
    setState(() {
      OwnerController.markAsComplete(widget.bid);
      widget.bid.status = "owner_marked_as_complete";
    });
  }
}
