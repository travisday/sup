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
          name: userFrom.username,
          title: `${userFrom.username}: sup!`,
          badge: '1',
          sound: 'default',
        },
      };
      // Let push to the target device

      admin.messaging().sendToDevice(userTo.pushToken, payload)
      
      return null;
    }
  );

export const sendFollowRequest = functions.https.onCall(
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
          name: userFrom.username,
          title: `${userFrom.username} would like to be friends!`,
          badge: '1',
          sound: 'default',
        },
      };
      // Let push to the target device

      admin.messaging().sendToDevice(userTo.pushToken, payload)
      
      return null;
    }
  );

export const regenerateSups = functions.pubsub
  .schedule('every 24 hours')
  .onRun(() => {
    admin
      .firestore()
      .collection('users')
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(function(doc) {
          const max = doc.data().maxSup;
          doc.ref.update({ sendCount: max });
        });
      })
      .then(() => console.log('all sups regenerated'))
      .catch(error => {
        console.log(error);
        return null;
      });

    return null;
});

export const alertFriendSched = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async () => {
    console.log("---ALERT FRIEND STARTED---");
    admin.firestore().collection('users').get()
      .then(querySnapshot => {
        querySnapshot.forEach(async function(doc) {
          const user = doc.data()

          let twoweeksago = new Date();
          twoweeksago.setDate(twoweeksago.getDate() - 14)

          let threedaysago = new Date();
          threedaysago.setDate(threedaysago.getDate() - 3)
          
          const twoWeekActivity  = await admin.firestore().collection('users').doc(doc.id)
                                       .collection('activity').where('date', '>', twoweeksago).get();

          const threeDayActivity  = await admin.firestore().collection('users').doc(doc.id)
                                       .collection('activity').where('date', '>', threedaysago).get();

          
          let twoWeekAvg = twoWeekActivity.size / 14;
          let threeDayAvg = threeDayActivity.size / 3;
          
          if ( threeDayAvg < (.5 * twoWeekAvg)) {
          //if ( true ) {
            const friends  = await admin.firestore().collection('users').doc(doc.id)
                                       .collection('friends').limit(1).get();
          
            const friendID = friends.docs[0].id;

            const friend = await admin.firestore().collection('users').doc(friendID).get();
            
            console.log(friend?.data()?.username);
            console.log("2WA: "+twoWeekAvg);
            console.log("3DA: "+threeDayAvg);
            console.log(friend?.data()?.pushToken);
            
          
            //alert friend
            const payload: admin.messaging.MessagingPayload = {
              notification: {
                title: `SUP!`,
                body: `${user.username} hasn't gotten a lot of sups recently. Send them one!`,
                badge: '1',
                sound: 'default',
              },
            };

            admin.messaging().sendToDevice(friend?.data()?.pushToken, payload);
            console.log("SENT!");
          }  
          
        });
      })
      .then(() => console.log("---ALERT FRIEND ENDED---"))
      .catch(error => {
        console.log(error);
        return null;
      });
    
    
    return null;
});

