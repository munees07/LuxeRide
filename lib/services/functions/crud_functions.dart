import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luxeride/model/bike_model/bikes_model.dart';
import 'package:luxeride/model/bookings_model/bookings_model.dart';
import 'package:luxeride/model/car_model/cars_model.dart';
import 'package:luxeride/view/subscreens/add_screen.dart';

ValueNotifier<List<CarsModel>> carListNotifier = ValueNotifier([]);
ValueNotifier<List<BikesModel>> bikeListNotifier = ValueNotifier([]);
ValueNotifier<List<BookingsModel>> bookingsListNotifier = ValueNotifier([]);


Future<void> add(DataBases dataBase, value) async {
  final box = await openAllBox(dataBase);
  await box.add(value);
  getAllList(dataBase);
}

Future<Box<dynamic>> openAllBox(DataBases dataBase) async {
  switch (dataBase) {
    case DataBases.carDataBase:
      return await Hive.openBox<CarsModel>('carDb');
    case DataBases.bikeDataBase:
      return await Hive.openBox<BikesModel>('bikeDb');
    case DataBases.bookingsDataBase:
      return await Hive.openBox<BookingsModel>('bookingsDb');
  }
}

void clearnotifier(DataBases dataBase) {
  switch (dataBase) {
    case DataBases.carDataBase:
      carListNotifier.value.clear();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      carListNotifier.notifyListeners();
      break;
    case DataBases.bikeDataBase:
      bikeListNotifier.value.clear();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      bikeListNotifier.notifyListeners();
      break;
    case DataBases.bookingsDataBase:
      bookingsListNotifier.value.clear();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      bookingsListNotifier.notifyListeners();
      break;
  }
}

void addAllList(DataBases dataBase, List<dynamic> values) {
  switch (dataBase) {
    case DataBases.carDataBase:
      carListNotifier.value.addAll(values.cast<CarsModel>());
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      carListNotifier.notifyListeners();
      break;
    case DataBases.bikeDataBase:
      bikeListNotifier.value.addAll(values.cast<BikesModel>());
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      bikeListNotifier.notifyListeners();
      break;
    case DataBases.bookingsDataBase:
      bookingsListNotifier.value.addAll(values.cast<BookingsModel>());
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      bookingsListNotifier.notifyListeners();
      break;
  }
}

Future<void> getAllList(DataBases dataBase) async {
  final box = await openAllBox(dataBase);
  clearnotifier(dataBase);
  addAllList(dataBase, box.values.toList());
}


Future<void> delete(DataBases dataBase, int index) async {
  final box = await openAllBox(dataBase);
  await box.deleteAt(index);
  getAllList(dataBase);
}


Future<void> edit(DataBases dataBase, int index, dynamic value) async {
  final box = await openAllBox(dataBase);

  box.putAt(index, value);
  getAllList(dataBase);
}


