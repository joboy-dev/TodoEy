// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:todoey/screens/authentication/login.dart';
import 'package:todoey/screens/main/dialog_screens/upload_profile_picture.dart';
import 'package:todoey/shared/animations.dart';
import 'package:todoey/shared/constants.dart';
import 'package:todoey/shared/navigator.dart';
import 'package:todoey/shared/widgets/button.dart';
import 'package:todoey/shared/widgets/dialog.dart';

class AddProfilePicture extends StatefulWidget {
  const AddProfilePicture({super.key});

  static const String id = 'addprofilepic';

  @override
  State<AddProfilePicture> createState() => _AddProfilePictureState();
}

class _AddProfilePictureState extends State<AddProfilePicture>
    with TickerProviderStateMixin {
  // instantiate ImagePicker
  final ImagePicker _imagePicker = ImagePicker();

  // create file instance
  late File? _image = File('assets/images/default.jpg');

  // ANIMATION
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    _controller1 =
        AnimationController(vsync: this, duration: kAnimationDuration3);

    _controller2 =
        AnimationController(vsync: this, duration: kAnimationDuration3);

    _controller3 =
        AnimationController(vsync: this, duration: kAnimationDuration3);

    _controller1.forward().whenCompleteOrCancel(() {
      _controller2.forward().whenCompleteOrCancel(() {
        _controller3.forward();
      });
    });

    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeIn),
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeIn),
    );

    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeIn),
    );

    assignImage();

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  // function to assign image
  Future<void> assignImage() async {
    // assign value to the image
    _image = await convertAssetToFile('assets/images/default.jpg');
  }

  // function to convert asset file to file object
  Future<File> convertAssetToFile(String assetName) async {
    // Load the asset file as a byte stream
    final byteData = await rootBundle.load(assetName);

    // Create a file in the app's temporary directory
    final tempDir = await getApplicationDocumentsDirectory();
    final tempFile = File('${tempDir.path}/$assetName');

    // Write the byte stream to the file
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    return tempFile;
  }

  // function to select image from gallery
  Future selectImageFromGallery() async {
    // log('$_image');

    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      // set image to selected image
      setState(() {
        // convert XFile into a File object
        _image = File(image!.path);
        log('$_image');
      });

      showDialogBox(
        context: context,
        dismisible: false,
        screen: UploadProfilePicture(
          imageFile: _image ??
              File(
                  'C:/Users/USER/Desktop/Projects/Flutter/todoey/assets/images/default.jpg'),
        ),
      );
    }
  }

  // functio n to select image through camera
  Future selectImageFromCamera() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (_image != null) {
      // set image to selected image
      setState(() {
        // convert XFile into a File object
        _image = File(image!.path);
        log('$_image');
      });

      showDialogBox(
        context: context,
        dismisible: false,
        screen: UploadProfilePicture(
          imageFile: _image ??
              File(
                  'C:/Users/USER/Desktop/Projects/Flutter/todoey/assets/images/default.jpg'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 2.0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        title: Column(
          children: [
            SizedBox(height: 30.0),
            Text(
              'ADD PROFILE PICTURE',
              style: kAppBarTextStyle,
            ),
            SizedBox(height: 30.0),
          ],
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: kAppPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FadeTransition(
                  opacity: _animation1,
                  child: Text(
                    'Add your profile picture.\n\nIf you do not want to perform this action, you can click the skip button below.',
                    style: kGreyNormalTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 20.0),
                FadeTransition(
                  opacity: _animation2,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialogBox(
                          context: context,
                          dismisible: false,
                          screen: UploadProfilePicture(imageFile: _image!),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: kGreyTextColor,
                        backgroundImage:
                            AssetImage('assets/images/default.jpg'),
                        foregroundImage: FileImage(_image!),
                        radius: 120.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                FadeTransition(
                  opacity: _animation2,
                  child: Text(
                    'Select from the two options below on how you want to add your profile picture.',
                    style: kGreyNormalTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 30.0),

                // Buttons
                SlideTransition(
                  position: slideTransitionAnimation(
                      dx: 2, dy: 0, animation: _animation3),
                  child: FadeTransition(
                    opacity: _animation3,
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonIcon(
                            buttonText: 'Gallery',
                            onPressed: () {
                              selectImageFromGallery();
                            },
                            buttonColor: kYellowColor,
                            icon: Icons.photo_library,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: ButtonIcon(
                            buttonText: 'Camera',
                            onPressed: () {
                              selectImageFromCamera();
                            },
                            buttonColor: kGreenColor,
                            icon: FontAwesomeIcons.camera,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                // Skip button
                TextButton(
                  onPressed: () {
                    navigatorPushReplacementNamed(context, Login.id);
                  },
                  style: TextButton.styleFrom(),
                  child: Text(
                    'Skip>>',
                    style: kNormalTextStyle.copyWith(
                      color: kDarkYellowColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
