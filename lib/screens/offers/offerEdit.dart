import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:lakhimpur_kheri/localisation/localization_two/app_translations.dart';
import 'package:lakhimpur_kheri/localisation/localization_two/application.dart';
class OffersEdit extends StatefulWidget {
  final _userEmail;
  final _title;
  final _description;
  final _reference;
  final _uploadedFileURL;
  final _editImgURL ;
  final _docIdToUpdate ;
  final _isUpdate;

  OffersEdit(
      this._userEmail,
      this._title,
      this._description,
      this._reference,
      this._uploadedFileURL ,
      this._editImgURL,
      this._docIdToUpdate ,
      this._isUpdate);

  @override
  State<StatefulWidget> createState() {
    return _OffersEditState(this._userEmail, this._title,
        this._description,
        this._reference,
        this._uploadedFileURL,
        this._editImgURL,
        this._docIdToUpdate ,
        this._isUpdate);
  }
}


class _OffersEditState extends State<OffersEdit> {
  String _userEmail;
  File _image;
  var _imgURL;
  final db = Firestore.instance;
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _title;
  String _description;
  String _reference;
  String _uploadedFileURL;
  String _editImgURL ;
  String docIdToUpdate;
  bool isUpdate = false;

  _OffersEditState(
      this._userEmail,
      this._title,
      this._description,
      this._reference,
      this._uploadedFileURL,
      this._editImgURL,
      this.docIdToUpdate ,
      this.isUpdate
      );

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _referenceController = TextEditingController();
  final _uploadedFileURLController = TextEditingController();

  @override
  void initState() {
    _titleController.text=_title;
    _descriptionController.text =_description;
    _referenceController.text=_reference;
    _uploadedFileURLController.text=_uploadedFileURL;
    // TODO: implement initState
    super.initState();
  }


  clearForm() {
    setState(() {
      isUpdate = false;
      docIdToUpdate = null;
      _titleController.text = "";
      _descriptionController.text = "";
      _referenceController.text = "";
      _uploadedFileURLController.text = "";
      _editImgURL='';
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
    uploadPic();
  }

  Future uploadPic() async {
//    String fileName = basename(_image.path);
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('offers/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = ref.putFile(_image);

    var downURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downURL.toString();
    print("Download URl: $url");
//    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    setState(() {
      debugPrint("Set State............................ : $url");
      _imgURL = url;
      debugPrint("Set State.._imgURL.......................... : $_imgURL");
      print("Profile Picture uploaded");
//      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
    return url;
  }

  Future<void> addStudent() async {
    await db.collection("offers").add({
      'title': _title,
      'description': _description,
      'reference': _reference,
      'varified': true,
      'varified_by': 'me',
      'email': _userEmail,
      'img_url_1': _imgURL,
    }).then((documentReference) {
      print(documentReference.documentID);
      clearForm();
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> editStudent() async {
    await db.collection("offers").document(docIdToUpdate).updateData({
      'title': _title,
      'description': _description,
      'reference': _reference,
      'img_url_1': _imgURL,
      'varified': true,
      'varified_by': 'me',
      'email': _userEmail,
    }).then((documentReference) {
      clearForm();
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> deleteStudent(DocumentSnapshot doc) async {
    db.collection("offers").document(doc.documentID).delete();
    clearForm();
  }


  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  @override
  Widget build(BuildContext context) {


    debugPrint("ListTile Tapped");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),
        title: Text(AppTranslations.of(context).text("key_offers_add_title"),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:Column(
          children: <Widget>[
            Form(
              key: _formStateKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(top: 10.0),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        width: 100.0,
                        height: 80.0,
                        child: (_editImgURL != null)
                            ? Image.network(
                          _editImgURL,
                          fit: BoxFit.fill,
                        )
                            : Image.asset('assets/smwallet/d28.gif',
                        ),),
                      Align(
                        alignment: Alignment.center,
                        child: new SizedBox(
                          width: 100.0,
                          height: 80.0,
                          child: (_image != null)
                              ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                              : Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/lakhimpur-kheri-9307b.appspot.com/o/offers%2Fimage_picker5011740355025430539.jpg%7D?alt=media&token=f35c9175-e822-4cde-be9f-8044464c60f4",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30.0,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ],
                  ),
//                const Divider(
//                  height: 5.0,
//                ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: TextFormField(
                      maxLength: 150,
                      onSaved: (value) {
                        _title = value;
                      },
                      controller: _titleController,
                      decoration: InputDecoration(
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          labelText: AppTranslations.of(context).text("key_offers_add_title2"),
                          icon: Icon(
                            Icons.business_center,
                            color: Colors.green,
                          ),
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.green,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: TextFormField(
                      maxLength: 300,
                      onSaved: (value) {
                        _description = value;
                      },
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          labelText: AppTranslations.of(context).text("key_offers_add_description"),
                          icon: Icon(
                            Icons.business_center,
                            color: Colors.green,
                          ),
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.green,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: TextFormField(
                      maxLength: 100,
                      onSaved: (value) {
                        _reference = value;
                      },
                      controller: _referenceController,
                      decoration: InputDecoration(
                          focusedBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          labelText: AppTranslations.of(context).text("key_offers_add_reference"),
                          icon: Icon(
                            Icons.dialpad,
                            color: Colors.green,
                          ),
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.green,
                          )),
                    ),
                  ),
                ],
              ),
            ),
prefix0.SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text(AppTranslations.of(context).text("key_offers_button_add"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (isUpdate) {
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();
                        editStudent();
                      }
                    } else {
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();
                        addStudent();
                      }
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text(AppTranslations.of(context).text("key_offers_button_clear"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    clearForm();
                  },
                ),
              ],
            ),
          ],
        ),),
    );
  }
}
