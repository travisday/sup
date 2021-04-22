import { setScore } from './db/setScore';
import { admin, functions } from './services';

// const mods = [0.1, 0.12, 0.14, 0.16, 0.18, 0.2, 0.22];

export const sendMessage = functions.https.onCall(
  async ({ idTo, idFrom }: { idTo?: string; idFrom: string }) => {
    // console.log('----------------start function--------------------');
    console.log(idTo, idFrom);
    if (!idTo || !idFrom)
      return console.log(`parameters not supplied, to: ${idTo} from ${idFrom}`);
    // Get push token user to (receive)
    const userToSnap = await admin
      .firestore()
      .collection('users')
      .doc(idTo)
      .get();

    const userTo = userToSnap.data();
    if (!userTo) return console.log(`user ${idTo} does not exist`);
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

    var rec = admin
      .firestore()
      .collection('users')
      .doc(idTo);
    var sender = admin
      .firestore()
      .collection('users')
      .doc(idFrom);
    // Let push to the target device

    const p1 = addRecScore(rec);
    const p2 = decSenderCount(sender);
    const p3 = addSenderScore(sender);

    await Promise.all([p1, p2, p3]).catch(error => {
      console.log('Error sending message:', error);
    });
    admin
      .messaging()
      .sendToDevice(userTo.pushToken, payload)
      .then(response => {
        console.log('Successfully sent message:', response);
      });
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

const addRecScore = async (rec: FirebaseFirestore.DocumentReference) => {
  try {
    return setScore(rec, current => {
      if (current < 10) return current + 1;
      return current + 0.3;
    });
  } catch (e) {
    console.error(`error adding receiver score`);
    console.error(e);
    return null;
  }
};

const addSenderScore = async (sender: FirebaseFirestore.DocumentReference) => {
  try {
    return setScore(sender, current => {
      if (current < 10) return current + 1;
      return current + 0.1;
    });
  } catch (e) {
    console.error(`error adding sender score`);
    console.error(e);
    return null;
  }
};

function decSenderCount(
  sender: FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>
) {
  admin.firestore().runTransaction(async transaction => {
    const doc = await transaction.get(sender);
    if (!doc.exists) {
      throw 'Document does not exist';
    }
    const newCount = doc?.data()?.sendCount - 1;
    if (!(newCount < 0)) {
      transaction.update(sender, {
        sendCount: newCount,
      });
    }
    console.log('Count updated');
  });
}
