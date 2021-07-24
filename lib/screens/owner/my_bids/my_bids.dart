import 'package:WSHCRD/firebase_services/owner_controller.dart';
import 'package:WSHCRD/models/bid.dart';
import 'package:WSHCRD/models/request.dart';
import 'package:WSHCRD/screens/owner/my_bids/bid_details_view.dart';
import 'package:WSHCRD/utils/global.dart';
import 'package:WSHCRD/utils/session_controller.dart';
import 'package:WSHCRD/widget/request_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyBidsView extends StatefulWidget {
  static const routeName = 'MyBids';

  @override
  _MyBidsViewState createState() => _MyBidsViewState();
}

class _MyBidsViewState extends State<MyBidsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'MY BIDS'.toUpperCase(),
          style: TextStyle(color: kTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Color(0xFFa1a1a1),
                labelPadding: EdgeInsets.symmetric(horizontal: 12),
                labelStyle: TextStyle(height: 1),
                onTap: (index) {},
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ACTIVE BIDS"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("COMPLETED TASKS"),
                  ),
                ],
                isScrollable: false,
              ),
              Expanded(
                child: TabBarView(children: [
                  getBids(active:true),
                  getBids(active:false),
                ]),
              )
            ],
          )),
    );
  }

  Widget getBids({bool active}) {
    var ownerId = SessionController
        .getOwnerInfoFromLocal()
        .ownerId;
    return
      StreamBuilder<QuerySnapshot>(
          stream: active
              ? OwnerController.getOwnerActiveBids(ownerId)
              : OwnerController.getOwnerCompletedTasks(ownerId),
          builder: (context, snapshot) {
            int count = 0;
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data.documents.length > 0) {
              count = snapshot.data.documents.length;
              return ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  Bid bid = Bid
                      .fromJson(
                      snapshot.data.documents[index].data);
                  Request request = bid.request;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RequestCard(
                        request: request,
                        color: kColorSlabs[index % kColorSlabs.length],
                        onPressedSeeBid: () {
                          Navigator.of(context).pushNamed(
                            BidDetailsView.routeName,
                            arguments: BidDetailsViewArguments(bid),
                          );
                        }
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No ${active?"Active":"Completed"} Bids"),
              );
            }
          });
  }
}
