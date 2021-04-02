import { admin } from '../services';

/**
 * the data stored in a document that should be passed in.
 *
 * currently don't make any assumptions about anything besides the score
 * because we don't validate this data in any way.
 */
type IUser = {
  score?: number;
  [key: string]: unknown;
};

/**
 *
 * @param ref the reference to the user data obj
 * @param setFn gets the old score and return a new score.
 * @returns
 */
export const setScore = (
  ref: FirebaseFirestore.DocumentReference<IUser>,
  setFn: (oldScore: number, user: unknown) => number
) =>
  admin.firestore().runTransaction(async transaction => {
    const doc = await transaction.get(ref);
    if (!doc.exists) {
      throw 'Document does not exist';
    }
    const user = doc.data();
    const oldScore: number = Number(user?.score) || 0;
    return transaction.update(ref, {
      // do not allow score below zero,
      // even if ur a chode
      score: setFn(Math.max(oldScore, 0), user),
    });
  });
