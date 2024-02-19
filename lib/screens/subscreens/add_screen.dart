import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luxeride/db/functions/crud_functions.dart';
import 'package:luxeride/db/model/bikes_model.dart';
import 'package:luxeride/db/model/cars_model.dart';
import 'package:luxeride/widgets/addscreen_widgets.dart';
import 'package:luxeride/widgets/global_widgets.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

enum DataBases { carDataBase, bikeDataBase,bookingsDataBase }

class _AddScreenState extends State<AddScreen> {
  DataBases selectedDatabase = DataBases.carDataBase;
  final companycontroller = TextEditingController();
  final modelcontroller = TextEditingController();
  final powercontroller = TextEditingController();
  final torquecontroller = TextEditingController();
  final dailypricecontroller = TextEditingController();
  final monthlypricecontroller = TextEditingController();
  File? selectedImage;
  final _formkey = GlobalKey<FormState>();

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
                const Gap(60),
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
                              ? FileImage(selectedImage!)
                              : const AssetImage('assets/images/addimage.png')
                                  as ImageProvider)),
                ),
                const Gap(10),
                FilledButtonWidget(
                    buttontext: 'ADD IMAGE',
                    onPressedButton: () {
                      pickImageFromGallery();
                    }),
                DropdownButton<DataBases>(
                  value: selectedDatabase,
                  items: const [
                    DropdownMenuItem(
                        value: DataBases.carDataBase, child: Text('Cars')),
                    DropdownMenuItem(
                        value: DataBases.bikeDataBase, child: Text('Bikes')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDatabase = value!;
                    });
                  },
                ),
                const Gap(10),
                AddFormField(
                    maxLength: 10,
                    inputformat: r'[a-z,A-Z," "]',
                    keyboardType: TextInputType.text,
                    hintText: 'company name',
                    controller: companycontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a company name';
                      } else {
                        return null;
                      }
                    }),
                AddFormField(
                    maxLength: 15,
                    inputformat: r'[a-z,A-Z," ",0-9]',
                    keyboardType: TextInputType.text,
                    hintText: 'model name',
                    controller: modelcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a model name';
                      } else {
                        return null;
                      }
                    }),
                AddFormField(
                    maxLength: 10,
                    inputformat: r'[a-z,A-Z," ",0-9]',
                    keyboardType: TextInputType.text,
                    hintText: 'horse power',
                    controller: powercontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a horse power';
                      } else {
                        return null;
                      }
                    }),
                AddFormField(
                    maxLength: 10,
                    inputformat: r'[0-9]',
                    keyboardType: TextInputType.text,
                    hintText: 'torque',
                    controller: torquecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a torque';
                      } else {
                        return null;
                      }
                    }),
                AddFormField(
                    maxLength: 7,
                    inputformat: r'[0-9]',
                    keyboardType: TextInputType.number,
                    hintText: 'daily price',
                    controller: dailypricecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a daily price';
                      } else {
                        return null;
                      }
                    }),
                AddFormField(
                    maxLength: 10,
                    inputformat: r'[0-9]',
                    keyboardType: TextInputType.number,
                    hintText: 'monthly price',
                    controller: monthlypricecontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a monthly price';
                      } else {
                        return null;
                      }
                    }),
                const Gap(10),
                FilledButtonWidget(
                    buttontext: 'ADD',
                    onPressedButton: () {
                      if (_formkey.currentState!.validate()) {
                        onAddClicked();
                        clearText();
                        dialoguebox();
                      }
                    }),
                const Gap(10)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onAddClicked() async {
    if (selectedDatabase == DataBases.carDataBase) {
      final company = companycontroller.text.trim();
      final model = modelcontroller.text.trim();
      final power = powercontroller.text.trim();
      final torque = torquecontroller.text.trim();
      final dailyprice = dailypricecontroller.text.trim();
      final monthlyprice = monthlypricecontroller.text.trim();
      if (company.isEmpty ||
          model.isEmpty ||
          power.isEmpty ||
          torque.isEmpty ||
          dailyprice.isEmpty ||
          monthlyprice.isEmpty) {
        return;
      }
      print('$company $model $power $torque $dailyprice $monthlyprice');

      final car = CarsModel(
          companyName: company,
          modelName: model,
          horsePower: power,
          torque: int.parse(torque),
          priceDay: int.parse(dailyprice),
          priceMonth: int.parse(monthlyprice),
          image: selectedImage!.path);
      add(DataBases.carDataBase, car);
    } else if (selectedDatabase == DataBases.bikeDataBase) {
      final company = companycontroller.text.trim();
      final model = modelcontroller.text.trim();
      final power = powercontroller.text.trim();
      final torque = torquecontroller.text.trim();
      final dailyprice = dailypricecontroller.text.trim();
      final monthlyprice = monthlypricecontroller.text.trim();
      if (company.isEmpty ||
          model.isEmpty ||
          power.isEmpty ||
          torque.isEmpty ||
          dailyprice.isEmpty ||
          monthlyprice.isEmpty) {
        return;
      }
      print('$company $model $power $torque $dailyprice $monthlyprice');

      final bike = BikesModel(
          companyName: company,
          modelName: model,
          horsePower: power,
          torque: int.parse(torque),
          priceDay: int.parse(dailyprice),
          priceMonth: int.parse(monthlyprice),
          image: selectedImage!.path);
      add(DataBases.bikeDataBase, bike);
    }
  }

  Future pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) {
      return;
    }

    setState(() {
      selectedImage = File(returnImage.path);
    });
  }

  void clearText() {
    companycontroller.clear();
    modelcontroller.clear();
    powercontroller.clear();
    torquecontroller.clear();
    dailypricecontroller.clear();
    monthlypricecontroller.clear();
    setState(() {
      selectedImage = null;
    });
  }

  void dialoguebox() {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) => AlertDialog(
              scrollable: true,
              content: const Text('Added Successfully'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }
}
