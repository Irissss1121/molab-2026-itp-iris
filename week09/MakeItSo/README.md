# Week 09 – MakeItSo + Firebase

For Week 09, I used the class **09-MakeItSo** project as a starting point to learn how an iOS app can save and retrieve data from the cloud using Firebase Firestore.

## What I Did

- Cloned the `09-MakeItSo` class example and tested the original app.
- Created my own Firebase project called `Iris-MakeItSo`.
- Changed the Bundle Identifier in Xcode.
- Registered my iOS app in Firebase.
- Replaced the original Firebase configuration with my own `GoogleService-Info.plist`.
- Created a Cloud Firestore database.
- Added reminders in the app and verified that they appeared in my Firestore database.
- Restarted the app and confirmed that the reminders were still available from the cloud.

## What I Learned

In previous weeks, I used `@AppStorage` and JSON files to save data locally. This week I learned how Firebase Firestore can store app data remotely in the cloud.

The app reads and writes a `reminders` collection in Firestore, and changes made in the app are reflected in the cloud database.

## AI Use

I used ChatGPT to help me understand the Firebase setup process and connect the class example to my own Firebase project.

Representative prompts included:

- “I cloned the MakeItSo class example. How do I connect it to my own Firebase project?”
- “Where do I change the Bundle Identifier in Xcode?”
- “How do I register the iOS app in Firebase and replace `GoogleService-Info.plist`?”
- “How can I check whether the reminders are actually being saved in my own Firestore database?”

I followed the setup steps myself in Xcode and Firebase Console and tested the result by adding reminders, checking Firestore, and restarting the app.

## Reference

Class example: `molab-itp/09-MakeItSo`

Original MakeItSo project/tutorial by Peter Friese.
