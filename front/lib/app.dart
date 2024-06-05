import 'package:doctolib/constant.dart';
import 'package:flutter/material.dart';
import 'package:doctolib/pages/splash_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // builder: (context, child) => ResponsiveWrapper.builder(
        //     BouncingScrollWrapper.builder(context, child!),
        //     maxWidth: MediaQuery.of(context).size.width,
        //     minWidth: MediaQuery.of(context).size.width,
        //     defaultScale: true,
        //     breakpoints: [
        //       const ResponsiveBreakpoint.resize(450, name: MOBILE),
        //       const ResponsiveBreakpoint.autoScale(800, name: TABLET),
        //       const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
        //       const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        //       const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        //     ],
        //     background: Container(color: const Color(0xFFF5F5F5))),
        debugShowCheckedModeBanner: false,
        title: 'DOCTO-DJIB',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: bleu,
          secondaryHeaderColor: grey,
        ),
        home: const SplashScreen());
  }
}
