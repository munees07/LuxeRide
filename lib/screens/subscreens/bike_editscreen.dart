import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luxeride/db/functions/crud_functions.dart';
import 'package:luxeride/db/model/bikes_model.dart';
import 'package:luxeride/screens/subscreens/add_screen.dart';
import 'package:luxeride/widgets/addscreen_widgets.dart';
import 'package:luxeride/widgets/global_widgets.dart';

class BikeEditScreen extends StatefulWidget {
  const BikeEditScreen(
      {super.key,
      required this.index,
      required this.companyName,
      required this.modelName,
      required this.power,
      required this.torque,
      required this.dailyPrice,
      required this.monthPrice,
      this.imagepath});

  final String companyName;
  final String modelName;
  final String power;
  final int torque;
  final int dailyPrice;
  final int monthPrice;
  final int index;
  final dynamic imagepath;

  @override
  State<BikeEditScreen> createState() => _BikeEditScreenState();
}

class _BikeEditScreenState extends State<BikeEditScreen> {
  final companycontroller = TextEditingController();
  final modelcontroller = TextEditingController();
  final powercontroller = TextEditingController();
  final torquecontroller = TextEditingController();
  final dailypricecontroller = TextEditingController();
  final monthlypricecontroller = TextEditingController();
  File? selectedImage;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    companycontroller.text = widget.companyName;
    modelcontroller.text = widget.modelName;
    powercontroller.text = widget.power;
    torquecontroller.text = widget.torque.toString();
    dailypricecontroller.text = widget.dailyPrice.toString();
    monthlypricecontroller.text = widget.monthPrice.toString();
    selectedImage = widget.imagepath != '' ? File(widget.imagepath) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0x00f3f5f7),
            child: Column(
              children: [
                const Gap(30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  height: 150,
                  child: Card(
                    shadowColor: Colors.black54,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Image(
                        fit: BoxFit.contain,
                        image: selectedImage != null
                            ? FileImage(
                                selectedImage!,
                              )
                            : const AssetImage(
                                    'assets/images/avatarPerson.jpeg')
                                as ImageProvider),
                  ),
                ),
                const Gap(10),
                FilledButtonWidget(
                    buttontext: 'ADD IMAGE',
                    onPressedButton: () {
                      pickImageFromGallery(ImageSource.gallery);
                    }),
                AddFormField(
                    inputformat: r'[a-z,A-Z," "]',
                    keyboardType: TextInputType.text,
                    hintText: 'company name',
                    maxLength: 10,
                    controller: companycontroller),
                AddFormField(
                    inputformat: r'[a-z,A-Z," ",0-9]',
                    keyboardType: TextInputType.text,
                    hintText: 'model name',
                    maxLength: 10,
                    controller: modelcontroller),
                AddFormField(
                    inputformat: r'[a-z,A-Z," ",0-9]',
                    keyboardType: TextInputType.text,
                    hintText: 'horse power',
                    maxLength: 10,
                    controller: powercontroller),
                AddFormField(
                    inputformat: r'[0-9]',
                    keyboardType: TextInputType.number,
                    hintText: 'torque',
                    maxLength: 10,
                    controller: torquecontroller),
                AddFormField(
                    inputformat: r'[0-9]',
                    keyboardType: TextInputType.number,
                    hintText: 'daily price',
                    maxLength: 7,
                    controller: dailypricecontroller),
                AddFormField(
                    inputformat: r'[0-9]',
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    hintText: 'monthly price',
                    controller: monthlypricecontroller),
                const Gap(10),
                FilledButtonWidget(
                    buttontext: 'UPDATE',
                    onPressedButton: () {
                      updateAll();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateAll() async {
    final newcompany = companycontroller.text.trim();
    final newmodel = modelcontroller.text.trim();
    final newpower = powercontroller.text.trim();
    final newtorque = torquecontroller.text.trim();
    final newdailyprice = dailypricecontroller.text.trim();
    final newmonthprice = monthlypricecontroller.text.trim();
    final newimage = selectedImage!.path;

    if (newcompany.isEmpty ||
        newmodel.isEmpty ||
        newpower.isEmpty ||
        newtorque.isEmpty ||
        newdailyprice.isEmpty ||
        newmonthprice.isEmpty ||
        newimage.isEmpty) {
      return;
    } else {
      final update = BikesModel(
          companyName: newcompany,
          modelName: newmodel,
          horsePower: newpower,
          torque: int.parse(newtorque),
          priceDay: int.parse(newdailyprice),
          priceMonth: int.parse(newmonthprice),
          image: newimage);

      edit(DataBases.bikeDataBase, widget.index, update);
      Navigator.pop(context);
    }
  }

  Future pickImageFromGallery(source) async {
    final returnImage = await ImagePicker().pickImage(source: source);

    if (returnImage == null) {
      return;
    }

    setState(() {
      selectedImage = File(returnImage.path);
    });
  }
}