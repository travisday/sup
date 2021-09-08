import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

export const sendMessage = functions.https.onCall(
    async ({idTo, idFrom}: {idTo?: string; idFrom: string}) => {
      // console.log('----------------start function--------------------');
      console.log(idTo, idFrom);
      if (!idTo || !idFrom)
        return console.log("parameters not supplied, to: ${idTo} from ${idFrom}");
      // Get push token user to (receive)
      const userToSnap = await admin
        .firestore()
        .collection('users')
        .doc(idTo)
        .get();
  
      const userTo = userToSnap.data();
      if (!userTo) return console.log("user ${idTo} does not exist");
      console.log(`Found user to: ${userTo.name}`);
      if (!userTo.pushToken) {
        console.log('no pushToken for target user');
        return;
      }
      // Get info user from (sent)
  
      const userFromSnap = await admin
        .firestore()
        .collection('users')
        .doc(idFrom)
        .get();
  
      const userFrom = userFromSnap.data();
      if (!userFrom) return console.log(`user ${idFrom} does not exist`);
      console.log(`Found user from: ${userFrom.name}`);
  
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          from: idFrom,
          name: userFrom.name,
          title: `${userFrom.name}: sup`,
          badge: '1',
          sound: 'default',
        },
      };
  
    
      // Let push to the target device

      admin.messaging().sendToDevice(userTo.pushToken, payload)
      
      return null;
    }
  );