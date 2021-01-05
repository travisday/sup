import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

exports.sendMessage = functions.https.onCall(
  async ({ idTo, idFrom }: { idTo?: string; idFrom: string }) => {
    console.log("----------------start function--------------------");

    // Get push token user to (receive)
    admin
      .firestore()
      .collection("users")
      .where("id", "==", idTo)
      .get()
      .then((querySnapshot) => {
        querySnapshot.forEach((userTo) => {
          console.log(`Found user to: ${userTo.data().name}`);
          if (!userTo.data().pushToken) {
            console.log("Can not find pushToken target user");
            return;
          }
          // Get info user from (sent)
          admin
            .firestore()
            .collection("users")
            .where("id", "==", idFrom)
            .get()
            .then((querySnapshot2) => {
              querySnapshot2.forEach((userFrom) => {
                console.log(`Found user from: ${userFrom.data().name}`);
                const payload: admin.messaging.MessagingPayload = {
                  notification: {
                    title: `${userFrom.data().name}: sup`,
                    badge: "1",
                    sound: "default",
                  },
                };
                // Let push to the target device
                admin
                  .messaging()
                  .sendToDevice(userTo.data().pushToken, payload)
                  .then((response) => {
                    console.log("Successfully sent message:", response);
                  })
                  .catch((error) => {
                    console.log("Error sending message:", error);
                  });
              });
            });
        });
      });
    return null;
  }
);
