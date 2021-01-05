import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

exports.sendSupNotification = functions.firestore
  .document("sups/{userFrom}/{userTo}/{sup}")
  .onCreate(async (snap, context) => {
    console.log("----------------start function--------------------");
    const sup = snap.data();
    console.log(sup);
    const { from: idFrom, to: idTo } = sup;

    if (!idTo) {
      console.error("no idTo");
      return null;
    }
    if (!idFrom) {
      console.error("no idFrom");
      return null;
    }
    // Get push token user to (receive)
    const userTo = await admin
      .firestore()
      .collection("users")
      .doc(idTo)
      .get()
      .then((snap) => snap.data());

    if (!userTo) {
      console.error("no user for idTo " + idTo);
      return null;
    }
    console.log(`Found user to: ${userTo.name}`);
    if (!userTo.pushToken) {
      console.log("Can not find pushToken target user");
      return;
    }
    // Get info user from (sent)
    const userFrom = await admin
      .firestore()
      .collection("users")
      .doc(idFrom)
      .get()
      .then((snap) => snap.data());

    if (!userFrom) {
      console.error("no user for idFrom " + idFrom);
      return null;
    }

    console.log(`Found user from: ${userFrom.name}`);
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `${userFrom.data().name}: sup`,
        badge: "1",
        sound: "default",
      },
    };
    // Let push to the target device
    await admin
      .messaging()
      .sendToDevice(userTo.pushToken, payload)
      .then((response) => {
        console.log("Successfully sent message:", response);
      })
      .catch((error) => {
        console.log("Error sending message:", error);
      });
    return null;
  });
