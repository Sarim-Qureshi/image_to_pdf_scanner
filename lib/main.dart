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
        title: Text("Image To PDF Scanner"),
        centerTitle: true, 
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                createPDF();
                savePDF();
Future.delayed(const Duration(milliseconds: 500), () {

  setState(() {
    _image.clear();
  });

});

                // setState(() {
                //   _image.clear();
                // });
              }),
            // IconButton(
            //   icon: Icon(Icons.restore_page),
            //   onPressed: () {
            //    setState(() {
            // _image.clear();
            //   });
            //   })
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        child: ListView(
          padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 60, 140, 231),
                        Color.fromARGB(255, 0, 234, 255),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 2.0,
                ),
                ListTile(
                  title: Center(
                    child: Text('Image to PDF Scanner'),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
                Divider(
                  height: 2.0,
                ),
                Builder(
                  builder: (context) => ListTile(
                    title: Text('Clear Page'),
                    leading: Icon(Icons.restore_page),
                    onTap: () {
                      setState(() {
                        _image.clear();
                        
                      });
                      Navigator.pop(context);
                    }
                    
                  ),
                ),
                Builder(
                  builder: (context) => ListTile(
                    title: Text('About Us'),
                    leading: Icon(Icons.person),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AboutUs()
                      ));
                    }
                    
                  ),
                ),
               
              
              ]
        )
      
      ),
      
floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: Color.fromARGB(255, 12, 144, 221),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.photo),
              label: 'Gallery/Documents',
              backgroundColor: Color.fromARGB(255, 12, 144, 221),
              onTap: () {getImageFromGallery();},
            ),
            SpeedDialChild(
              child: const Icon(Icons.add_a_photo),
              label: 'Camera',
              backgroundColor: Color.fromARGB(255, 12, 144, 221),
              onTap: () {getImageFromCamera();},
            )
 
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

Future.delayed(const Duration(milliseconds: 500), () {
 setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });

});

    
    
  }

getImageFromCamera() async {
     final pickedFile = await picker.getImage(source: ImageSource.camera);
    
Future.delayed(const Duration(milliseconds: 500), () {
 setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });

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


class AboutUs extends StatefulWidget {


  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true, 
        
      ),
      body: Column (
        
        children: <Widget>[
          Text("\n\"Image to PDF Scanner\"", textAlign: TextAlign.start,
          style: TextStyle(fontSize: 22 ),
          ),
          Text("\n Made by the following TE5 IT students of Shah & Anchor Kutchhi Engineering College for MAD&PWA lab during the academic year 2021-2022\n\n", textAlign: TextAlign.start,
          style: TextStyle(fontSize: 22 ),
          ),
         
         
          // Text("\n\"Image to PDF Scanner\" \n made by the following TE5 IT students of Shah & Anchor Kutchhi Engineering College during the academic year 2021-2022 \nfor the lab MAD&PWA\n", textAlign: TextAlign.start,
          // style: TextStyle(fontSize: 22 ),
          // ),

          Text("Janhavi Porwal     TE5 40", textAlign: TextAlign.start,
        style: TextStyle(fontSize: 19 ),), 
        Text("Shivam Prajapati    TE5 41", textAlign: TextAlign.start,
        style: TextStyle(fontSize: 19 ),),
         Text("Sarim Qureshi    TE5 42", textAlign: TextAlign.start,
         style: TextStyle(fontSize: 19 ),         
         ),
           Text("\n\nGuided By", textAlign: TextAlign.start,
        style: TextStyle(fontSize: 15 ),),
          Text("Mr. Dhwaniket Kamble", textAlign: TextAlign.start,
        style: TextStyle(fontSize: 19 ),),
         ],
      )

     );}
}