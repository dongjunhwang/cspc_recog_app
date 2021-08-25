import 'dart:io';

import 'package:cspc_recog/attendance/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../urls.dart';

class ProfileDrawerPage extends StatefulWidget {
  @override
  ProfileEditPageState createState() => ProfileEditPageState();
}

class ProfileEditPageState extends State<ProfileDrawerPage> {
  bool _edit = false;
  XFile _profileImage;
  TextEditingController _nickNameController;
  ProfileModel profile;
  @override
  void initState() {
    super.initState();
    _nickNameController = TextEditingController();
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getMyProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              profile = snapshot.data;

              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        profile.profileImageUrl == null
                            ? Icon(
                                Icons.account_circle,
                                size: 150,
                              )
                            : Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: _profileImage == null
                                          ? NetworkImage(UrlPrefix.urls
                                                  .substring(
                                                      0,
                                                      UrlPrefix.urls.length -
                                                          1) +
                                              profile.profileImageUrl)
                                          : Image.file(File(_profileImage.path))
                                              .image),
                                ),
                              ),
                        _edit
                            ? Positioned(
                                child: IconButton(
                                  onPressed: () async {
                                    _profileImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.photo_camera,
                                    size: 50,
                                  ),
                                ),
                                bottom: 0,
                                right: 0,
                              )
                            : Container()
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: !_edit
                                ? Text(
                                    "${profile.nickName}",
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: TextField(
                                      controller: _nickNameController,
                                      decoration: InputDecoration(
                                          hintText: profile.nickName),
                                    ),
                                  ),
                          ),
                          !_edit
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _edit = true;
                                    });
                                  },
                                  icon: Icon(Icons.edit))
                              : FloatingActionButton(
                                  onPressed: () async {
                                    return await saveProfile();
                                  },
                                  child: Text("save"),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  saveProfile() async {
    try {
      final request = http.MultipartRequest(
          "POST",
          Uri.parse(UrlPrefix.urls +
              'users/profile/update/' +
              '${profile.profileId}'));

      request.fields['newNickName'] = _nickNameController.text;
      if (_profileImage != null)
        request.files.add(await http.MultipartFile.fromPath(
            'profileImage', _profileImage.path));
      request.send();
    } catch (e) {
      print(e);
    }
    setState(() {
      _edit = false;
    });
  }

  Future<ProfileModel> getMyProfile() async {
    ProfileModel myProfile;
    try {
      final response = await http.get(
        Uri.parse(UrlPrefix.urls + "users/1"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        myProfile = ProfileModel.fromJson(data);
      }
    } catch (e) {
      print(e);
    }

    return myProfile;
  }
}
