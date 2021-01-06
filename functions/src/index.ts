import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

exports.sendMessage = functions.https.onCall(
  async ({ idTo, idFrom }: { idTo?: string; idFrom: string }) => {
    console.log("----------------start function--------------------");
    console.log(idTo, idFrom);
    if (!idTo || !idFrom) return;
    // Get push token user to (receive)
    const userToSnap = await admin
      .firestore()
      .collection("users")
      .doc(idTo)
      .get();

    const userTo = userToSnap.data();
    if (!userTo) return;
    console.log(`Found user to: ${userTo.name}`);
    if (!userTo.pushToken) {
      console.log("Can not find pushToken target user");
      return;
    }
    // Get info user from (sent)

    const userFromSnap = await admin
      .firestore()
      .collection("users")
      .doc(idFrom)
      .get();

    const userFrom = userFromSnap.data();
    if (!userFrom) return;
    console.log(`Found user from: ${userFrom.name}`);
    if (!userFrom.pushToken) {
      console.log("Can not find pushToken target user");
      return;
    }
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `${userFrom.name}: sup`,
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
  }
);
