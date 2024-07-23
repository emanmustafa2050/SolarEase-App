import 'dart:ui';
import 'package:app/api_objects/user.dart';
import 'package:app/filterpost.dart';
import 'package:flutter/material.dart';
// Assuming this is the destination after login

bool isvalid = false;
bool _isloading = false;
bool clicked = false;
User userlogin = User(
    username: "username",
    password: "",
    email: "",
    location: "location",
    phoneNumber: "phoneNumber",
    city: "city");
String error = "Please Enter All Field";

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // MaterialApp(
        //   home:
        LoginPage();
    // );
  }
}

/**************************************************************/
//main widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double scw;
  late double sch;
  late double t;

  double wid(double w) {
    return scw * (w / 380);
  }

  double hig(double h) {
    return (h / 592) * sch;
  }

  @override
  Widget build(BuildContext context) {
    scw = MediaQuery.of(context).size.width;
    sch = MediaQuery.of(context).size.height;
    t = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              TopRightImage(wid: wid(190), hig: hig(76.96)),
              Spacer(flex: 1),
              CenterImage(wid: wid(266), hig: hig(148)),
              TitleText(t: t),
              SizedBox(height: hig(14.8)),
              LoginForm(
                  wid: wid,
                  hig: hig,
                  //handel api here
                  onPressed: handleLogin),
              !isvalid && clicked
                  ? SizedBox(height: hig(5))
                  : SizedBox(height: hig(14.8)),
              Spacer(flex: 1),
              BottomLeftImage(wid: wid(190), hig: hig(76.96)),
            ],
          ),
          if (_isloading)
            const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black)),
          if (_isloading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  /****************************************************** */
  Future<void> handleLogin() async {
    if (userlogin.email == '' || userlogin.password == '') {
      setState(() {
        error = "Please Enter All Field";
        isvalid = false;
        clicked = true;
      });
    } else {
      setState(() {
        _isloading = true;
      });

      // Simulate sending data to an API
      var response = await userlogin.checkuser();

      setState(() {
        _isloading = false;
      });
      if (response == 'Ok') {
        setState(() {
          clicked = isvalid = true;

          final User u = User(
            username: userlogin.username,
            password: '',
            email: userlogin.email,
            location: userlogin.location,
            phoneNumber: userlogin.phoneNumber,
            city: userlogin.city,
          );
          u.id = userlogin.id;

          u.useKey = userlogin.useKey;
          print(u.useKey);
          print("*************************************************");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return FilterPost(u: u);
            }),
          );

          //reset for new user
          userlogin.email = '';
          userlogin.password = '';
          clicked = false;
          isvalid = false;
          _isloading = false;
          clicked = false;
        });
      } else {
        setState(() {
          clicked = true;
          isvalid = false;
          error = response;
        });
      }
    }
  }
}

/*****************************************************/
// widget for top right image
class TopRightImage extends StatelessWidget {
  final double wid;
  final double hig;

  const TopRightImage({required this.wid, required this.hig});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Image.asset(
        'assets/Login/4.png',
        width: wid,
        height: hig,
        alignment: Alignment.centerRight,
        fit: BoxFit.fill,
      ),
    );
  }
}

/*****************************************************/
// widget for centeral image
class CenterImage extends StatelessWidget {
  final double wid;
  final double hig;

  const CenterImage({required this.wid, required this.hig});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/Login/1.png',
      width: wid,
      height: hig,
    );
  }
}

/*****************************************************/
// widget for "Welcome" text
class TitleText extends StatelessWidget {
  final double t;

  const TitleText({required this.t});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome',
      style: TextStyle(
        fontSize: 25.0 * t,
        fontWeight: FontWeight.bold,
        color: Color(0xff063221),
      ),
    );
  }
}

/*****************************************************/
// widget for username and password input as form
class LoginForm extends StatelessWidget {
  final double Function(double) wid;
  final double Function(double) hig;
  final VoidCallback onPressed;

  LoginForm({
    required this.wid,
    required this.hig,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          buildTextFieldRow(
            icon: Icons.person,
            label: '  Email',
            width: wid(228),
            height: hig(32.56),
            onChanged: (value) => userlogin.email = value,
          ),
          SizedBox(height: hig(14.8)),
          buildTextFieldRow(
            icon: Icons.password,
            label: '  Password',
            width: wid(228),
            height: hig(32.56),
            onChanged: (value) => userlogin.password = value,
          ),
          SizedBox(height: hig(14.8)),
          SizedBox(
            width: wid(200),
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(
                'LogIn',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Color(0xff063221),
              ),
            ),
          ),
          if (!isvalid && clicked) builderrorinputtext(error),
        ],
      ),
    );
  }

  Widget builderrorinputtext(String e) {
    return Text(
      e,
      style: TextStyle(color: Colors.red, fontSize: 13),
    );
  }

  /******************************/
  //widget for text field input
  Widget buildTextFieldRow({
    required IconData icon,
    required String label,
    required double width,
    required double height,
    required Function(String) onChanged,
  }) {
    return Row(
      children: [
        Spacer(flex: 2),
        Icon(icon, color: Color(0xff063221)),
        Spacer(flex: 1),
        SizedBox(
          width: width,
          height: height,
          child: TextField(
            obscureText: label == "  Password" ? true : false,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.grey),
              labelText: label,
              filled: true,
              fillColor: Color.fromARGB(255, 226, 234, 221),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        Spacer(flex: 2)
      ],
    );
  }
}

/***************************************/
//widget for most left bottom image
class BottomLeftImage extends StatelessWidget {
  final double wid;
  final double hig;

  const BottomLeftImage({required this.wid, required this.hig});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Image.asset(
        'assets/Login/3.png',
        width: wid,
        height: hig,
        alignment: Alignment.centerRight,
        fit: BoxFit.fill,
      ),
    );
  }
}




















/*import 'package:app/SignUp.dart';
import 'package:flutter/material.dart';
import 'homeuser.dart';

void main() => runApp(Login());
double scw = 0; // 60% of screen width
double sch = 0;
double t = 0;
double wid(double w) {
  return scw * (w / 380);
}

double hig(double h) {
  return (h / 592) * sch;
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    scw = MediaQuery.of(context).size.width; // 60% of screen width
    sch = MediaQuery.of(context).size.height;
    t = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Column(
        children: <Widget>[
          // صورة فوق خالص ناحية اليمين
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/Login/4.png',
              width: wid(190),
              height: hig(76.96),
              alignment: Alignment.centerRight,
              fit: BoxFit.fill,
            ),
          ),

          Spacer(flex: 1),
          //صورة في المنتصف 
          Image.asset(
            'assets/Login/1.png',
            width: wid(266),
            height: hig(148),
          ),

          Text(
            'Welcome',
            style: TextStyle(
              fontSize: 25.0 * t,
              fontWeight: FontWeight.bold,
              color: Color(0x0ff063221),
            ),
          ),
          SizedBox(height: hig(14.8)),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Spacer(
                      flex: 2,
                    ),
                    Icon(
                      Icons.person,
                      color: Color(0x0ff063221),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: wid(228), //200
                      height: hig(32.56), //30
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: '  Username',
                          filled: true,
                          fillColor: Color.fromARGB(255, 226, 234, 221),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    )
                  ],
                ),
                SizedBox(height: hig(14.8)),
                Row(
                  children: [
                    Spacer(
                      flex: 2,
                    ),
                    Icon(
                      Icons.password,
                      color: Color(0x0ff063221),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: wid(228), //200
                      height: hig(32.56), //30
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: '  Password',
                          filled: true,
                          fillColor: Color.fromARGB(255, 226, 234, 221),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    )
                  ],
                ),
                SizedBox(height: hig(14.8)),
                SizedBox(
                  width: wid(152), //200
                  height: hig(32.56), //30
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return HomeUser();
                      }));
                    },
                    child: Text(
                      'LogIn',
                      style: TextStyle(
                        fontSize: 15, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Color(0x0ff063221),
                    ),
                  ),
                ),
                SizedBox(height: hig(14.8)),
                Text(
                  'forget Pssword ?',
                  style: TextStyle(
                    fontSize: 15.0 * t,
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: wid(9.5)),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return SignUp();
                  }));
                },
                child: Text(
                  "Don't have an accout ?",
                  style: TextStyle(
                    fontSize: 15.0 * t,
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // صورة تحت خالص ناحية الشمال
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/Login/3.png',
              width: wid(190),
              height: hig(76.96),
              alignment: Alignment.centerRight,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
*/
