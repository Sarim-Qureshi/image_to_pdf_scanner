import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> _image = [];


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image To PDF"),
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                createPDF();
                savePDF();
              })
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: getImageFromGallery,
      // ),
      
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       onPressed: getImageFromGallery,
      //       child: Icon(Icons.photo),
      //     ),
      //     FloatingActionButton(
      //       onPressed: getImageFromCamera,
      //       child: Icon(Icons.camera_alt),
            
      //     ),
      //   ]
      // ),
floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: Color.fromARGB(255, 12, 144, 221),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.browse_gallery),
              label: 'Gallery/Documents',
              backgroundColor: Color.fromARGB(255, 12, 144, 221),
              onTap: () {getImageFromGallery();},
            ),
            SpeedDialChild(
              child: const Icon(Icons.add_a_photo),
              label: 'Camera',
              backgroundColor: Color.fromARGB(255, 12, 144, 221),
              onTap: () {getImageFromCamera();},
            ),
            // SpeedDialChild(
            //   child: const Icon(Icons.chat),
            //   label: 'Message',
            //   backgroundColor: Colors.amberAccent,
            //   onTap: () {/* Do something */},
            // ),
          ]),



      body: _image != null
          ? ListView.builder(
              itemCount: _image.length,
              itemBuilder: (context, index) => Container(
                  height: 400,
                  width: double.infinity,
                  margin: EdgeInsets.all(8),
                  child: Image.file(
                    _image[index],
                    fit: BoxFit.cover,
                  )),
            )
          : Container(),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

getImageFromCamera() async {
     final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
}

  createPDF() async {
    for (var img in _image) {
      final image = pw.MemoryImage(img.readAsBytesSync());

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(child: pw.Image(image));
          }));
    }
  }

  savePDF() async {
    try {
      
      final dir = await getExternalStorageDirectory();
      DateTime now =  DateTime.now();
      final file = File('${dir.path}/PDF_'+now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString()
       +"_"+now.hour.toString()+":"+now.minute.toString()+":"+now.second.toString()
       +":"+now.millisecond.toString()+".pdf");
      await file.writeAsBytes(await pdf.save());
      showPrintedMessage('Success', 'Saved To Documents');
    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.info,
        color: Colors.blue,
      ),
    )..show(context);
  }
}