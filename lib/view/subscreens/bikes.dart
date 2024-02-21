import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:luxeride/services/functions/crud_functions.dart';
import 'package:luxeride/model/bike_model/bikes_model.dart';
import 'package:luxeride/view/subscreens/add_screen.dart';
import 'package:luxeride/view/subscreens/bike_editscreen.dart';
import 'package:luxeride/view/subscreens/piechart.dart';
import 'package:luxeride/view/screens/vehicle_details.dart';

class BikePage extends StatefulWidget {
  const BikePage({super.key});

  @override
  State<BikePage> createState() => _BikePageState();
}

class _BikePageState extends State<BikePage> {
  String search = "";
  List<BikesModel> searchedList = [];

  void searchListUpdate() {
    getAllList(DataBases.bikeDataBase);
    searchedList = bikeListNotifier.value
        .where(
          (bike) =>
              bike.companyName!.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    searchListUpdate();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: TextFormField(
          cursorColor: Colors.black,
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
          decoration: InputDecoration(
              prefixIconColor: Colors.black,
              prefixIcon: const Icon(Icons.search),
              hintText: 'search..',
              hintStyle: const TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey))),
        ),
      ),
      body: Column(
        children: [
          const Gap(20),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: bikeListNotifier,
                builder: (context, List<BikesModel> bikeList, child) {
                  return SizedBox(
                    child: search.isNotEmpty
                        ? searchedList.isEmpty
                            ? Center(
                                child: Column(
                                  children: [
                                    const Text('No bikes available'),
                                    const Gap(90),
                                    Lottie.asset(
                                        width: 250,
                                        'assets/icons/noItems.json'),
                                  ],
                                ),
                              )
                            : bikeListwidget(searchedList)
                        : bikeListwidget(bikeList),
                  );
                }),
          )
        ],
      ),
    );
  }

  List<int> bikeSum = [];

  Widget bikeListwidget(List<BikesModel> bikelist) {
    return bikelist.isEmpty
        ? Center(
            child: Column(
              children: [
                const Text('No bikes available'),
                const Gap(90),
                Lottie.asset(width: 250, 'assets/icons/noItems.json'),
              ],
            ),
          )
        : ListView.builder(
            itemCount: bikelist.length,
            itemBuilder: (context, index) {
              final data = bikelist[index];
              bikeSum.add(data.priceDay);
              double totalbike = bikeSum
                  .reduce(
                    (value, element) => value + element,
                  )
                  .toDouble();
              Chart.bikevalue = totalbike;
              return Column(
                children: [
                  Slidable(
                    endActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.grey.shade300,
                          onPressed: (context) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BikeEditScreen(
                                    index: index,
                                    companyName: data.companyName!,
                                    modelName: data.modelName,
                                    power: data.horsePower,
                                    torque: data.torque,
                                    dailyPrice: data.priceDay,
                                    monthPrice: data.priceMonth,
                                    imagepath: data.image)));
                          },
                          icon: Icons.edit),
                      const Gap(5),
                      SlidableAction(
                        borderRadius: BorderRadius.circular(15),
                        backgroundColor: Colors.redAccent,
                        onPressed: (context) {
                          showDialog(
                              context: context,
                              useSafeArea: true,
                              builder: (context) => AlertDialog(
                                    scrollable: true,
                                    content: const Text('Are you sure?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            delete(
                                                DataBases.bikeDataBase, index);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'DELETE',
                                            style: TextStyle(color: Colors.red),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.black)))
                                    ],
                                  ));
                        },
                        icon: CupertinoIcons.delete,
                      ),
                      const Gap(5)
                    ]),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                companyName: data.companyName!,
                                modelName: data.modelName,
                                horsePower: data.horsePower,
                                torque: data.torque.toString(),
                                dailyPrice: data.priceDay.toString(),
                                monthlyPrice: data.priceMonth.toString(),
                                imagepath: data.image ?? "")));
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: Card(
                          shadowColor: Colors.black54,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Positioned(
                                  right: 20,
                                  left: 80,
                                  child: Image(
                                      fit: BoxFit.scaleDown,
                                      image: data.image != null
                                          ? FileImage(File(data.image!))
                                          : const AssetImage(
                                                  'assets/images/addimage.png')
                                              as ImageProvider)),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 14, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.companyName!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                    Text(data.modelName,
                                        style: const TextStyle(fontSize: 8))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(19)
                ],
              );
            },
          );
  }
}
