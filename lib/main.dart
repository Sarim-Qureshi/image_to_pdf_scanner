import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import 'theme_provider.dart';

main() {
  runApp(MaterialApp(
    home: ChangeNotifierProvider<DynamicTheme>(create: (_) => DynamicTheme(),
    // debugShowCheckedModeBanner: false,
    child: MyApp())
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

  final themeProvider = Provider.of<DynamicTheme>(context);
 
  return Scaffold(
     

            appBar: AppBar(
             
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Image to PDF"),
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                createPDF();
                savePDF();
              }),
        ],
              )
      ,
      
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 48, 153, 185),
        child: ListView(
          padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Image.asset(
                    'assets/images/logo_app.png',
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
                    Navigator.pop(context);
                  },
                ),
                  Builder(
                  builder: (context) => ListTile(
                    title: Text('Toggle Dark mode'),
                    leading: Icon(Icons.brightness_4),
                    onTap: () {
                      setState(() {
                        themeProvider.changeDarkMode(!themeProvider.isDarkMode);
                      });
                      Navigator.pop(context);
                    },
                    trailing: CupertinoSwitch(
                      value: themeProvider.getDarkMode(),
                      onChanged: (value) {
                        setState(() {
                          themeProvider.changeDarkMode(value);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ]
        )
      
      ),
      
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImageFromGallery,
      ),
    
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
                  ),
                  
                  ),
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
      showPrintedMessage('success', 'saved to documents');
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



