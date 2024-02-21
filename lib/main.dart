import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luxeride/model/car_model/cars_model.dart';
import 'package:luxeride/view/screens/splash.dart';
import 'model/bike_model/bikes_model.dart';
import 'model/bookings_model/bookings_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CarsModelAdapter().typeId)) {
    Hive.registerAdapter(CarsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BikesModelAdapter().typeId)) {
    Hive.registerAdapter(BikesModelAdapter());
  }
  if (!Hive.isAdapterRegistered(BookingsModelAdapter().typeId)) {
    Hive.registerAdapter(BookingsModelAdapter());
  }
  Hive.openBox<CarsModel>('carDb');
  Hive.openBox<BookingsModel>('bookingsDb');
  Hive.openBox<BikesModel>('bikeDb');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black, fontFamily: 'Michroma'),
    );
  }
}
