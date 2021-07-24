import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/widget/request_card.dart';
import 'package:flutter/material.dart';

class BidPostedViewArguments {
  final Request request;
  final Bid bid;

  BidPostedViewArguments(this.request, this.bid);
}

class BidPostedView extends StatefulWidget {
  final Request request;
  final Bid bid;

  static const routeName = "/bid-posted-view";

  const BidPostedView({Key key, this.request, this.bid}) : super(key: key);

  @override
  _BidPostedViewState createState() => _BidPostedViewState();
}

class _BidPostedViewState extends State<BidPostedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackgroundGradient(),
          buildPageContent(),
        ],
      ),
    );
  }

  Positioned buildBackgroundGradient() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFAD80CB),
            Color(0xFF7451E9),
          ],
        )),
      ),
    );
  }

  Widget buildPageContent() {
    return Positioned.fill(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child: Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "YOUR BID HAS BEEN POSTED",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RequestCard(
              request: widget.request,
              showPriority: true,
              showCategory: true,
            ),
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 29),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: Text(
                    "your bid",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
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
                Container(
                  width: double.infinity,
                  height: 42,
                  margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 40),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "BACK TO NEARBY REQUESTS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8));
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.black;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
