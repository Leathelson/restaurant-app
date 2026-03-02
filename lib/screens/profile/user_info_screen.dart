import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luxury_restaurant_app/screens/profile/buildTextField.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final usersCollection = FirebaseFirestore.instance.collection("users");

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(
                  "Edit $field",
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: TextField(
                  autofocus: true,
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor),
                  decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: TextStyle(
                        color: Theme.of(context)
                            .appBarTheme
                            .foregroundColor
                            ?.withOpacity(0.6)),
                  ),
                  onChanged: (value) {
                    newValue = value;
                  },
                ),
                actions: [
                  //cancel button
                  TextButton(
                    child: Text('Cancel',
                        style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor)),
                    onPressed: () => Navigator.pop(context),
                  ),

                  //save button
                  TextButton(
                    child: Text('Save',
                        style: TextStyle(
                            color:
                                Theme.of(context).appBarTheme.foregroundColor)),
                    onPressed: () => Navigator.of(context).pop(newValue),
                  ),
                ]));

    //update Firestore
    if (newValue.trim().length > 0) {
      //only update if there is something in the textfield
      await usersCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: Theme.of(context).appBarTheme.foregroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              //get user data
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Profile Picture
                        const Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage("assets/images/profile.png"),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt,
                                  size: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Name field
                        MyTextBox(
                          label: "Name",
                          bgColor: Theme.of(context).colorScheme.primary,
                          text: userData['Name'],
                          onPressed: () => editField("Name"),
                        ),

                        // Email field
                        MyTextBox(
                          label: "Email",
                          bgColor: Theme.of(context).colorScheme.secondary,
                          text: userData['Email'],
                          onPressed: () => editField("Email"),
                        ),

                        // Phone field
                        MyTextBox(
                          label: "Phone Number",
                          bgColor: Theme.of(context).colorScheme.primary,
                          text: userData['Phone'],
                          onPressed: () => editField("Phone"),
                        ),

                        Text(currentUser.email!,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .foregroundColor
                                    ?.withOpacity(0.6)))
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("Error=${snapshot.error}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .appBarTheme
                                .foregroundColor)));
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}
