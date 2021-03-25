import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sup/api/auth.dart';
import 'package:sup/model/user.dart';
import 'package:sup/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sup/api/user_service.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  File _image;
  final picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      //userService.uploadFile(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthState>(context).user;

    var text;
    if (user == null)
      text = 'no user';
    else if (user.name == null)
      text = 'hi ' + user.email;
    else
      text = 'hi ${user.name}!';

    return Theme(
      // Find and extend the parent theme using "copyWith".
      data: Theme.of(context).copyWith(
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ThemeData.dark().buttonTheme,
      ),
      child: Flex(direction: Axis.horizontal, children: [
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text(text,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 0, 15),
                    child: CircleAvatar(
                        backgroundImage: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ).image
                            : NetworkImage(
                                'https://robohash.org/{$user.id}.png?set=set1?bgset=bg3'),
                        radius: 80)),
                FlatButton(
                  child: Text('Update Profile Pic',
                      style: TextStyle(fontSize: 18)),
                  onPressed: _openImagePicker,
                ),
                FlatButton(
                  child: Text('Switch Theme', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .switchTheme();
                  },
                ),
                FlatButton(
                  child: Text('Log Out', style: TextStyle(fontSize: 18)),
                  onPressed: FirebaseAuth.instance.signOut,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
