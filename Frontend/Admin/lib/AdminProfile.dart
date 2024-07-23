import 'package:app/api_objects/user.dart';
import 'package:app/filterpost.dart';
import 'package:flutter/material.dart';

import 'Login.dart'; // Assuming Login.dart contains your Login widget

double scw = 0;
double sch = 0;
double t = 0;
double wid(double w) {
  return scw * (w / 380);
}

double hig(double h) {
  return (h / 592) * sch;
}

class AdminProfile extends StatelessWidget {
  @override
  AdminProfile({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBody(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

/**********************************************/
//main widget
class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    scw = MediaQuery.of(context).size.width;
    sch = MediaQuery.of(context).size.height;
    t = MediaQuery.of(context).textScaleFactor;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //header
          ProfileHeader(
            wid: wid,
            hig: hig,
            t: t,
          ),
          SizedBox(height: hig(60)),

          buildDivider(wid, hig),

          ProfileMenuItem(
            text: '      Log out',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => Login()));
              print('Log out clicked');
            },
            wid: wid,
            t: t,
          ),
          buildDivider(wid, hig),
          Spacer(),
        ],
      ),
    );
  }

/**********************************************/
//widget for create grey divider
  Widget buildDivider(Function(double) wid, Function(double) hig) {
    return Container(
      height: hig(3),
      width: wid(273.35),
      color: Color(0xffD1D1D1),
    );
  }
}

/**********************************************/
//widget for create user picture and his name and email and image
class ProfileHeader extends StatelessWidget {
  final Function(double) wid;
  final Function(double) hig;
  final double t;

  const ProfileHeader({
    required this.wid,
    required this.hig,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: hig(220),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: hig(30),
            child: ClipOval(
              child: Image.asset(
                "assets/profile/8.png",
                width: hig(80),
                height: hig(80),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: hig(110),
            child: Text(
              user.username,
              style: TextStyle(
                color: Color(0xff063221),
                fontSize: 17 * t,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: hig(130),
            child: Text(
              user.email,
              style: TextStyle(
                color: Color(0xff607C71),
                fontSize: 12 * t,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: hig(100),
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/profile/9.png',
              width: double.infinity,
              height: hig(120),
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}

/**********************************************/
//widget for create diffrent choices
class ProfileMenuItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Function(double) wid;
  final double t;

  const ProfileMenuItem({
    required this.text,
    required this.onTap,
    required this.wid,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            SizedBox(width: wid(37.5)),
            Text(
              text,
              style: TextStyle(
                color: Color(0xff607C71),
                fontSize: 15 * t,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**********************************************/
//widget for bottom navigation bar

/**********************************************/
//widget for bottom navigation bar
class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffECECEC),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: [
            Spacer(
              flex: 1,
            ),
            _buildIconItem(Icons.home, 'Home', () {
              Navigator.pop(context);
            }),
            Spacer(
              flex: 2,
            ),
            _buildIconItem(Icons.person, 'Profile', () {
              // Add onTap functionality for Profile
            }),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

/**********************************************/
//widget for each item in navigation bar
  Widget _buildIconItem(IconData iconData, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: hig(62),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                size: 30,
                color: text == "Profile"
                    ? Color.fromARGB(136, 6, 50, 33)
                    : Color(0xff063221),
              ),
              SizedBox(height: 3),
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff063221),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
