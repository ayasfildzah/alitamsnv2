// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names

import 'dart:convert';
import 'package:alitamsniosmobile/Navigator/navigator.dart';
import 'package:alitamsniosmobile/Surveycomplaint/dashboardcompaint.dart';
import 'package:alitamsniosmobile/Surveycomplaint/homesurvey.dart';
import 'package:alitamsniosmobile/WFH/dashboardwfh.dart';
import 'package:alitamsniosmobile/WFH/homewfh.dart';
import 'package:alitamsniosmobile/Workout/dashboardworkoutside.dart';
import 'package:alitamsniosmobile/Workout/homeworkout.dart';
import 'package:alitamsniosmobile/backend/constants.dart';
import 'package:alitamsniosmobile/fragment.dart';
import 'package:alitamsniosmobile/home.dart';
import 'package:alitamsniosmobile/homecheckin.dart';
import 'package:alitamsniosmobile/screens/DashboardCheckin.dart';
import 'package:alitamsniosmobile/screens/about.dart';
import 'package:alitamsniosmobile/token.dart';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  String password;

  User(this.username, this.password);

  factory User.fromJson(dynamic json) {
    return User(json['username'] as String, json['password'] as String);
  }

  @override
  String toString() {
    return '{ ${this.username}, ${this.password} }';
  }
}

class Login extends StatefulWidget {
  //const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { signIn }

class _LoginState extends State<Login> {
  // ignore: unused_field
  //late LoginStatus _loginStatus ;
  Color primaryColor = Color(0xff486493);
  bool _rememberMe = false;
  late SharedPreferences Preferences;
  late String email, password;
  late String name;
  late String errormessage;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;
  bool? newuser;
  bool _isHidePassword = true;
  bool _isLoading = false;
  int? value;
  ProgressDialog _progressDialog = ProgressDialog();

  void _togglePasswordvisible() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;

    if (form!.validate()) {
      form.save();
      login(email, password);

      //  Preferences.setString('name', email);
    }
  }

  login(email, password) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? pref = preferences.getString('user');
    Map datashow = {'email': email, 'password': password};
    print(datashow.toString());
    try {
      final response =
          await http.post("https://msn.alita.massindo.com/api/v1/users/sign_in",
              headers: {
                "Accept": "application/json",
                'Cookie':
                    '_alita_session=yCQcwRoFitVDZkP%2BbXwjuWtGRJ4%2Bj46LQidbc7HQvT4RvBhEJhaXRBHvWQN0B4HWsFZdo11fjgNgrsSK87Z2rwuSwFw6U7LQlLhuADXJ9vTZke98233s8g%2BJAgNEjnhKjLpP%2BN1HtJkItlaBHkxQSw%3D%3D--kJGWhaZ1KC62%2BE4O--1NuBEgTP5kTchk8TgOcuPQ%3D%3D'
              },
              body: datashow);
      if (response.statusCode == 200) {
        _progressDialog.dismissProgressDialog(context);
        final data = jsonDecode(response.body);
        int value = data['value'];
        int id = data['id'];
        String namaAPI = data['name'];
        if (id != null) {
          // final list = data['user'];
          // final img = data['image'];
          // Map<String, dynamic> data =
          //     new Map<String, dynamic>.from(json.decode(response.body));

          // ignore: unused_local_variable
          String pesan = data['status'];
          String error = data['error'];
          String emailAPI = data['email'];

          String showimage = data['image_url'];

          String no = data['phone'].toString();
          String last = data['last_sign_in_with_authy'];
          int area = data['area_id'];
          int compny = data['company_id'];
          preferences.setBool('login', false);
          setState(() {
            _isLoading = false;
            savePref(value, emailAPI, namaAPI, id, showimage, no, last, area,
                compny);
          });

          // print(response.body);
          // print(namaAPI);
          // print(namaAPI);
          // preferences.setString('name', namaAPI);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Selamat Datang" + " " + namaAPI)));
          // Fluttertoast.showToast(
          //     msg: "Selamat Datang" + " ",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          //     );
        } else {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Invalid email and password combination",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

              );
          print(response.body);
        }
      }
    } catch (e) {
      print("Error getting users.");
      Fluttertoast.showToast(
          msg: "Sorry,Alita Out of Service",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM // also possible "TOP" and "CENTER"

          );
    }
  }

  savePref(int value, String email, String nama, int id, String image,
      String hp, String last, int ar, int company) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("name", nama);
      preferences.setString("email", email);
      preferences.setInt("id", id);
      preferences.setString("last_sign_in_with_authy", last.toString());
      preferences.setString("image_url", image.toString());
      preferences.setString("phone", hp);
      preferences.setInt("area_id", ar);
      preferences.setInt("company_id", company);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  getPref() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      var name = preferences.getString("name");
      var stts = preferences.getString("status");
      var lat = preferences.getString("latitude_user");
      var long = preferences.getString("longitude_user");
      var loc = preferences.getString("location");
      // ignore: unused_local_variable
      LoginStatus _loginStatus =
          value == value ? LoginStatus.signIn : LoginStatus.signIn;
      if (name != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home()));
      }
      // if (stts != null) {
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (context) => const Homecheckin()));
      // }
      if (lat != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeWfh()));
      }
      if (long != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeWorkout()));
      }
      if (loc != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeSurvey()));
      } else {
        Login();
      }
      print(lat);
      // runApp(MaterialApp(
      //   home: value == null ? Login() : Homecheckin(),
      // ));
      // } else {
      //   runApp(MaterialApp(
      //     // ignore: unnecessary_null_comparison
      //     home: stts == null ? Login() : MyDashboard(),
      //   ));
      // }
    });
  }

  // signOut() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     preferences.setInt("value", null);
  //     // ignore: deprecated_member_use
  //     preferences.commit();
  //     _loginStatus = LoginStatus.notSignIn;
  //   });
  // }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getPref();
  }

  void _showerrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Warning',
          style: TextStyle(color: Colors.blue),
        ),
        content: Text(message),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (e) {
              if (e!.isEmpty) {
                return "Please insert email";
              }
            },
            onSaved: (e) => email = e!,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (e) {
              if (e!.isEmpty) {
                return "Please insert password";
              }
            },
            onSaved: (e) => password = e!,
            obscureText: _isHidePassword,
            autofocus: false,
            initialValue: '',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  _togglePasswordvisible();
                },
                child: Icon(
                  _isHidePassword ? Icons.visibility_off : Icons.visibility,
                  color: _isHidePassword ? Colors.black : Colors.blue,
                ),
              ),
              hintText: ' Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      alignment: Alignment.topRight,
      height: 35.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Theme(
          //   data: ThemeData(unselectedWidgetColor: Colors.white),
          //   child: Checkbox(
          //     value: _rememberMe,
          //     checkColor: Colors.green,
          //     activeColor: Colors.white,
          //     onChanged: (value) {
          //       setState(() {
          //         _rememberMe = value!;
          //       });
          //     },
          //   ),
          // ),
          Text(
            'Lupa Password ?',
            style: TextStyle(color: Colors.blue),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 150,
      child: MaterialButton(
        elevation: 8.0,
        onPressed: () {
          check();
          var showProgressDialog = _progressDialog.showProgressDialog(
            context,
            textToBeDisplayed: 'loading...',
          );
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: primaryColor,
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset('assets/text.png',
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 1.5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/db.png'),
                  fit: BoxFit.fill,
                ),
              ),
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [
              //       primaryColor,
              //       primaryColor,
              //       Color(0xFFFFFDE0),
              //       Color(0xFFFFFDE0),
              //     ],
              //     stops: [0.1, 0.4, 0.7, 0.9],
              //   ),
              // ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome To Alita',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sign in to your account to continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 50.0),
                    _buildEmailTF(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTF(),
                    // _buildForgotPasswordBtn(),
                    _buildRememberMeCheckbox(),
                    _buildLoginBtn(),
                    // _buildSignInWithText(),
                    _buildSocialBtnRow(),
                    //_buildSignupBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
