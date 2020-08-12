import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapp/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            final documents = snapshot.data.documents;
            return ListView.builder(
                reverse: true,
                itemCount: documents.length,
                itemBuilder: (context, i) => MessageBubble(
                      username: documents[i]['username'],
                      imageUrl: documents[i]['imageUrl'],
                      isMe: documents[i]['userId'] == futureSnapshot.data.uid,
                      message: documents[i]['text'],
                      uniqueKey: ValueKey(documents[i].documentID),
                    ));
          },
        );
      },
    );
  }
}
