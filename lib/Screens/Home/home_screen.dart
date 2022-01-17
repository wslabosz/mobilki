import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/resources/firestore_methods.dart';
import 'package:mobilki/screens/Home/components/body.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/resources/auth_methods.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Games'),
          leading: Row(children: <Widget>[IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => {
              AuthMethods().logout(),
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false)
            },
          ),IconButton(icon: const Icon(Icons.add),onPressed: ()  {
            ImagePicker imagePicker = ImagePicker();
            Future<XFile?> compressedImage = imagePicker.pickImage(
              source: ImageSource.gallery,
              imageQuality:66
            );
            compressedImage.then((result) {
              result?.readAsBytes().then((result) {
                FireStoreMethods().uploadAvatar(result,AuthMethods().getUserUID());
              });
            }); 
          })],
        )),
        body: const Body(),
        bottomNavigationBar: const Navbar(index: 0));
  }
}
