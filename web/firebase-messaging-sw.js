importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
   apiKey: 'AIzaSyAHyG7VmvZvuSCNkoqQiFqgxhX5QiPrfiI',
   appId: '1:536729021833:web:b4caa716337c6f04fac558',
   messagingSenderId: '536729021833',
   projectId: 'flutterfirebasedemo-a6a3c',
   authDomain: 'flutterfirebasedemo-a6a3c.firebaseapp.com',
   databaseURL: 'https://flutterfirebasedemo-a6a3c-default-rtdb.firebaseio.com',
   storageBucket: 'flutterfirebasedemo-a6a3c.appspot.com',
   measurementId: 'G-TSSRJ6N7JD',
});
//firebase.analytics();

// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
//messaging.onBackgroundMessage((payload) => {
//   console.log("onBackgroundMessage", payload);
//   const notificationTitle = payload.notification.title;
//   const notificationOptions = {body: payload.notification.body};
//   self.registration.showNotification(notificationTitle, notificationOptions);
//});