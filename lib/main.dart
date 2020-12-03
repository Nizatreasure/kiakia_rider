import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiakia_rider/change_notifier.dart';
import 'package:kiakia_rider/login_signup/signup.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<AllChangeNotifiers>(
      create: (context) => AllChangeNotifiers(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        home: Wrapper(),
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffe5e5e5),
            textTheme: TextTheme(
                bodyText1: TextStyle(
                    color: Color.fromRGBO(5, 54, 90, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                button: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                bodyText2: TextStyle(
                    color: Color.fromRGBO(81, 83, 82, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400))),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignUp();
  }
}
