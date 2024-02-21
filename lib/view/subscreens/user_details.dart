import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:luxeride/services/functions/crud_functions.dart';
import 'package:luxeride/model/bookings_model/bookings_model.dart';
import 'package:luxeride/view/subscreens/add_screen.dart';
import 'package:luxeride/view/widgets/addscreen_widgets.dart';
import 'package:luxeride/view/widgets/global_widgets.dart';

enum Pack { daily, monthly }

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen(
      {super.key, this.imagepath, this.companyname, this.modelname});
  final String? imagepath;
  final String? companyname;
  final String? modelname;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final companycontroller = TextEditingController();
  final modelcontroller = TextEditingController();
  final usercontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final licensecontroller = TextEditingController();
  final selectedPackcontroller = TextEditingController();
  File? selectedImage;
  Pack selectedPack = Pack.daily;
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
              const Gap(40),
              Center(
                  child: Text(widget.companyname!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 29))),
              Center(
                  child: Text(widget.modelname!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15))),
              const Gap(20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Image(
                      fit: BoxFit.contain,
                      image: FileImage(File(widget.imagepath!))),
                ),
              ),
              const Gap(20),
              const Text(
                'Enter Your Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Gap(10),
              AddFormField(
                maxLength: 15,
                inputformat: r'[a-z,A-Z," "]',
                hintText: 'Enter Your Name',
                keyboardType: TextInputType.name,
                controller: usercontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a name';
                  }
                  return null;
                },
              ),
              AddFormField(
                maxLength: 3,
                inputformat: r'[0-9]',
                hintText: 'Enter Age',
                keyboardType: TextInputType.number,
                controller: agecontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the age';
                  }
                  int? age = int.tryParse(value);
                  if (age == null || age < 1 || age > 150) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              AddFormField(
                maxLength: 20,
                inputformat: r'[a-z,A-Z," "]',
                hintText: 'Enter Address',
                keyboardType: TextInputType.streetAddress,
                controller: addresscontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the address';
                  }
                  return null;
                },
              ),
              AddFormField(
                maxLength: 15,
                inputformat: r'[0-9]',
                hintText: 'Enter License NO.',
                keyboardType: TextInputType.text,
                controller: licensecontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the license number';
                  }
                  return null;
                },
              ),
              DropdownButton<Pack>(
                  value: selectedPack,
                  items: const [
                    DropdownMenuItem(value: Pack.daily, child: Text('Daily')),
                    DropdownMenuItem(
                        value: Pack.monthly, child: Text('Monthly'))
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedPack = value!;
                    });
                  }),
              const Gap(10),
              FilledButtonWidget(
                  buttontext: 'PROCEED',
                  onPressedButton: () {
                    if (_formkey.currentState!.validate()) {
                      addClicked();
                      dialoguebox();
                    }
                  })
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> addClicked() async {
    if (selectedPack == Pack.daily) {
      selectedPackcontroller.text = 'Daily Pack';
    } else if (selectedPack == Pack.monthly) {
      selectedPackcontroller.text = 'Monthly Pack';
    }
    final image = widget.imagepath;
    final pack = selectedPackcontroller.text;
    final company = widget.companyname;
    final model = widget.modelname;
    final username = usercontroller.text;
    final age = agecontroller.text;
    final address = addresscontroller.text;
    final license = licensecontroller.text;

    log('$company $model $username');

    final bookings = BookingsModel(
        image: image,
        userName: username,
        age: age,
        address: address,
        license: license,
        package: pack,
        companyName: company,
        modelName: model!);

    add(DataBases.bookingsDataBase, bookings);
    Navigator.pop(context);
    
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
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }
}
