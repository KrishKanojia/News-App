import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/constraints.dart';
import 'package:news_app/screens/favouritescreen.dart';
import 'package:news_app/screens/profilescreen.dart';
import 'package:news_app/screens/search.dart';
import 'package:provider/provider.dart';

import 'provider/userdataprovider.dart';
import 'screens/homapage.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserDataProvider>(
          create: (ctx) => UserDataProvider(),
        ),
        // ListenableProvider<ProductProvider>(
        //   create: (ctx) => ProductProvider(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: CompanyColors.blackPrimaryValue,
        ),
        home: FutureBuilder(
          future: _initialization,
          builder: (context, AsyncSnapshot snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return WelcomeScreen();
            }

            return Container();
          },
          // SignUp(),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    searchScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _selectedIndex == 0 ? kprimary : Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _selectedIndex == 1 ? kprimary : Colors.black,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline,
              color: _selectedIndex == 2 ? kprimary : Colors.black,
            ),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: _selectedIndex == 3 ? kprimary : Colors.black,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kprimary,
        onTap: (index) {
          setState(() {
            this._selectedIndex = index;
          });
        },
      ),
    );
  }
}
