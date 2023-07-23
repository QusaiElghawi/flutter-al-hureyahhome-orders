import 'package:alhureyah_customer_service/view/widget/svgImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes.dart';
import 'list_notes.dart';


class AllOrders extends StatelessWidget {
   AllOrders({Key? key}) : super(key: key);

  CollectionReference noteRef = FirebaseFirestore.instance.collection('Notes');

  var uId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: noteRef
              .orderBy('Date', descending: true)
              .where('uid', isEqualTo: uId)
              .snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              return const Text('Error');
            }
            if (snapShot.hasData) {
              if (snapShot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapShot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListNotes(
                        notes: snapShot.data!.docs[index],
                        docId: snapShot.data!.docs[index].id,
                      );
                    });
              } else {
                return const SvgImage();
              }
            }
            return const SvgImage();
          },
        ));
  }

}
