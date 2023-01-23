import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_hour/blocs/internet_bloc.dart';
import 'package:travel_hour/blocs/user_bloc.dart';
import 'package:travel_hour/utils/snacbar.dart';

class ProfileEditPage extends StatefulWidget {
  final String imageUrl;
  final String name;

  ProfileEditPage({Key key, @required this.imageUrl, this.name})
      : super(key: key);

  @override
  _ProfileEditPageState createState() =>
      _ProfileEditPageState(this.imageUrl, this.name);
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  _ProfileEditPageState(this.imageUrl, this.name);

  String imageUrl;
  String name;
  File imageFile;
  String fileName;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future pickImage() async {
    var imagepicked = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);

    if (imagepicked != null) {
      setState(() {
        imageFile = imagepicked;
        fileName = (imageFile.path);
      });
    } else {
      print('No image has is selected!');
    }
  }

  Future uploadPicture() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String uid = sp.getString('uid');
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Profile Pictures/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    if (uploadTask.isComplete) {
      print('upload complete');
    }

    var _url = await (await uploadTask.onComplete).ref.getDownloadURL();
    var _imageUrl = _url.toString();
    setState(() {
      imageUrl = _imageUrl;
    });
  }

  handleSaveData() async {
    final UserBloc ub = Provider.of<UserBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if (ib.hasInternet == false) {
      openSnacbar(scaffoldKey, 'No internet connection');
    } else {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        setState(() {
          loading = true;
        });
        imageFile == null
            ? ub.updateNewData(name, imageUrl).then((_) {
                openSnacbar(scaffoldKey, 'Updated Successfully');
                setState(() {
                  loading = false;
                });
              })
            : uploadPicture()
                .then((value) => ub.updateNewData(name, imageUrl).then((_) {
                      openSnacbar(scaffoldKey, 'Updated Successfully');
                      setState(() {
                        loading = false;
                      });
                    }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            children: <Widget>[
              InkWell(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[800]),
                        color: Colors.grey[500],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageFile == null
                                ? CachedNetworkImageProvider(
                                    imageUrl != null ? imageUrl : "")
                                : FileImage(imageFile),
                            fit: BoxFit.cover)),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.black,
                        )),
                  ),
                ),
                onTap: () {
                  pickImage();
                },
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter New Name',
                    ),
                    initialValue: name,
                    validator: (value) {
                      if (value.length == 0) return "Name can't be empty";
                      return null;
                    },
                    onChanged: (String value) {
                      setState(() {
                        name = value;
                      });
                    },
                  )),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 45,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                  child: Text(
                    'Save Data',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    handleSaveData();
                  },
                ),
              ),
              SizedBox(
                height: 100,
              ),
              loading == true
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
            ],
          )),
    );
  }
}
