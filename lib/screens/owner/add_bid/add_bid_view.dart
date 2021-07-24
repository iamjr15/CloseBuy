import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/router.dart';
import 'package:WSHCRD/screens/owner/add_bid/bid_posted_view.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:WSHCRD/widget/request_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBidView extends StatefulWidget {
  static const routeName = "/add-bid-view";

  @override
  _AddBidViewState createState() => _AddBidViewState();
}

class _AddBidViewState extends State<AddBidView> {
  Request request;
  String amount;
  String type;

  @override
  Widget build(BuildContext context) {
    final AddBidViewArguments args = ModalRoute.of(context).settings.arguments;
    request = args.request;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Add Bid'.toUpperCase(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildRequestView(),
              buildAddBidButton(),
              buildBidAmountField(),
              ...buildDeliveryType(),
              buildSubmitButton(),
            ],
          ),
        ));
  }

  Widget buildAddBidButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
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
          "ADD BID",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget buildBidAmountField() {
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFE6D4D4), width: 3),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 6))
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "₹",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
              onChanged: (amount){
                this.amount = amount;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 16),
                border: InputBorder.none,
                hintText: "",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildDeliveryType() {
    return [
      SizedBox(height: 8,),
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Text(
            "delivery type",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      buildDeliveryTypePicker(context),
    ];
  }

  Widget buildDeliveryTypePicker(BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          height: 52,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: DropdownButtonFormField(
                  items: ["Home Delivery", "Store Pickup"]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (option) {
                    if(option == "Home Delivery")
                      this.type = "home_delivery";
                    if(option == "Store Pickup")
                      this.type = "store_pickup";
                  },
                  isDense: true,
                  // onChanged: onPicked,
                  iconSize: 0,
                  hint: Text("Select"),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Image.asset(
                "assets/icons/dropdown_arrow.png",
                width: 13,
                color: Colors.black,
              ),
              SizedBox(
                width: 16,
              )
            ],
          ),
        ),
      );

  Widget buildSubmitButton() {
     return Container(
      width: 160,
      height: 42,
      margin: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
      child: TextButton(
        onPressed: addBid,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.check,color: Colors.black,),
            ),
            Text(
              "SUBMIT",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 25,),
          ],
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
                return Color(0xFF48FF5B).withOpacity(0.5);
              else
                return Color(0xFF48FF5B);
            },
          ),
        ),
      ),
    );
  }

  RequestCard buildRequestView() {
    return RequestCard(request: request,);
  }

  void addBid() async{
    if(valid()){
      var bid = Bid();
      bid.amount = double.parse(this.amount);
      bid.type = type;
      bid.ownerId = SessionController
          .getOwnerInfoFromLocal()
          .ownerId;
      bid.request = request;
      bid.status = "bid_submitted";
      bid.storeName = SessionController.getOwnerInfoFromLocal().businessName;
      var loc = SessionController.getOwnerInfoFromLocal().location;
      bid.storeLocation = GeoPoint(loc.latitude, loc.longitude);

      showLoadingScreen();
      await OwnerController.submitNewBid(
        bid: bid,
      );
      closeLoadingScreen();
      Navigator.of(context).pushReplacementNamed(
        BidPostedView.routeName,
        arguments: BidPostedViewArguments(request, bid),
      );
    }
  }

  bool valid() {
    if(this.amount == null || this.amount.isEmpty){
      Global.showToastMessage(context: context, msg: "Amount cannot be empty");
      return false;
    }
    try{
      double.parse(this.amount);
    }on Exception catch(e){
      Global.showToastMessage(context: context, msg: "Invalid amount");
      return false;
    }
    if(this.type == null){
      Global.showToastMessage(context: context, msg: "Select delivery type");
      return false;
    }
    return true;
  }
}
