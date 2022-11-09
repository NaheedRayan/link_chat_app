import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  var msgText;
  var sentAt;
  var sentBy;
  var sentTo;

  MessageChat({
    required this.msgText,
    required this.sentAt,
    required this.sentBy,
    required this.sentTo,
  });

  Map<String, dynamic> toJson() {
    return {
    "msgText": this.msgText,
      "sentAt": this.sentAt,
      "sentBy": this.sentBy,
      "sentTo": this.sentTo,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    var msgText = doc.get("msgText");
    var sentAt = doc.get("sentAt");
    var sentBy = doc.get("sentBy");
    var sentTo = doc.get("sentTo");


    return MessageChat(msgText: msgText, sentAt: sentAt, sentBy: sentBy, sentTo: sentTo);
  }
}
