/**
 * should initialize and export all the firebase services we use
 */
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

export { functions, admin };
