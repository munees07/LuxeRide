import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luxeride/db/model/bikes_model.dart';
import 'package:luxeride/db/model/bookings_model.dart';
import 'package:luxeride/db/model/cars_model.dart';

import 'package:luxeride/screens/signup.dart';
import 'package:luxeride/screens/subscreens/about.dart';
import 'package:luxeride/screens/subscreens/piechart.dart';
import 'package:luxeride/screens/subscreens/privacy.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            color: const Color(0x00f3f5f7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(50),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(30),
                SettingsTile(
                    icon: const Icon(CupertinoIcons.info),
                    text: 'ABOUT',
                    onpressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AboutPage()));
                    }),
                const Gap(30),
                SettingsTile(
                    icon: const Icon(Icons.privacy_tip_outlined),
                    text: 'PRIVACY POLICY',
                    onpressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PrivacyPage()));
                    }),
                const Gap(30),
                SettingsTile(
                    icon: const Icon(CupertinoIcons.chart_bar_circle),
                    text: 'CHART',
                    onpressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyPieChart()));
                    }),
                const Gap(30),
                SettingsTile(
                    icon: const Icon(Icons.restart_alt),
                    text: 'RESET',
                    onpressed: () {
                      setState(() {
                        Hive.box<BikesModel>('bikeDb').clear();
                        Hive.box<CarsModel>('carDb').clear();
                        Hive.box<BookingsModel>('bookingsDb').clear();
                        dialoguebox();
                      });
                    }),
                const Gap(30),
                SettingsTile(
                    icon: const Icon(Icons.logout),
                    text: 'LOGOUT',
                    onpressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                          (route) => false);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dialoguebox() {
    showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) => AlertDialog(
              scrollable: true,
              content: const Text('Reseted Successfully'),
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

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onpressed,
  });
  final Icon icon;
  final String text;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: ListTile(
          leading: icon,
          title: Text(
            text,
            style: const TextStyle(fontSize: 12),
          )),
    );
  }
}
