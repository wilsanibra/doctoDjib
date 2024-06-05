import 'package:doctolib/constant.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bleu,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircleAvatar(
                    radius: width / 6.2,
                    backgroundImage: const AssetImage('assets/images/log.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: width,
                    height: width / 3,
                    // color: Colors.amberAccent,
                    child: Stack(
                      children: [
                        Positioned(
                          left: width / 3.5,
                          top: width * 0.15,
                          child: CircleAvatar(
                            radius: width / 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: const AssetImage(
                              'assets/images/ceringue.jpg',
                            ),
                          ),
                        ),
                        Positioned(
                          right: width / 3.2,
                          top: width * 0.04,
                          child: CircleAvatar(
                            radius: width / 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: const AssetImage(
                              'assets/images/boitephra.jpg',
                            ),
                          ),
                        ),
                        Positioned(
                          right: width * 0.3,
                          top: width / 4,
                          child: CircleAvatar(
                            radius: width / 25,
                            backgroundColor: Colors.transparent,
                            backgroundImage: const AssetImage(
                              'assets/images/tetoscope.webp',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.060,
                  bottom: height * 0.060,
                ),
                child: Text(
                  'DOCTO-DJIB',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.05,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const Login(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.start_sharp,
                  color: Colors.black,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  fixedSize: Size(
                    width / 2,
                    height / 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text(
                  'Get Started'.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    // fontSize: width * 0.06,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
