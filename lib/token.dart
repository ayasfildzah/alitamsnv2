import 'package:alitamsniosmobile/home.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

String? finalname;

class token extends StatefulWidget {
  const token({Key? key}) : super(key: key);

  @override
  _tokenState createState() => _tokenState();
}

class _tokenState extends State<token> {
  String mail = '';
  String pin = '';
  late EmailAuth emailAuth;
  bool _visible = false;
  final TextEditingController _Otp = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    //  getStringValuesSF();
  }

  // getStringValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return String
  //   mail = prefs.getString('email')!;

  //   setState(() {
  //     finalname = mail;
  //   });
  //   print("email = " + mail);
  //   return mail;
  // }

  void sendOTP() async {
    EmailAuth.sessionName = 'Test';
    var res = await EmailAuth.sendOtp(receiverMail: mail);
    if (res) {
      print("OTP Sent");
    } else {
      print("we could not sent the OTP");
    }
  }

  void verityOtp() {
    var res = EmailAuth.validate(receiverMail: mail, userOTP: _Otp.value.text);
    print("pin = " + mail);
    print("pin2 = " + _Otp.value.text);
    if (res) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyDashboard()),
      );
      print("OTP Verified");
    } else {
      print("Invalide Otp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP Screen"),
      ),
      body: Center(
        child: Container(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Image.asset("assets/password.png",
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Klik (Send Otp) untuk melanjutkan ke menu dashboard ",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.black,
                      fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                    onPressed: () => {
                          sendOTP(),
                          setState(() {
                            _visible = !_visible;
                          })
                        },
                    child: Text("Send OTP")),
                // PinEntryTextField(
                //     showFieldAsBox: true, onSubmit: (pin) => verityOtp(),
                //     // showDialog(
                //     //     context: context,
                //     //     builder: (context) {
                //     //       return AlertDialog(
                //     //         title: Text("Pin"),
                //     //         content: Text('Pin entered is $pin'),
                //     //       );
                //     //     }); //end showDialog()
                //     // end onSubmit
                //     ),
                // OTPTextField(
                //   length: 6,
                //   width: MediaQuery.of(context).size.width,
                //   textFieldAlignment: MainAxisAlignment.spaceAround,
                //   fieldWidth: 35,
                //   fieldStyle: FieldStyle.box,
                //   outlineBorderRadius: 10,
                //   style: TextStyle(fontSize: 14),
                //   onChanged: (pin) {
                //     print("Changed: " + pin);
                //   },
                //   onCompleted: (pin) {
                //     print("Completed: " + pin);
                //   },
                // ),
                Visibility(
                  visible: _visible,
                  child: Text(
                    " ~ Cek Email Anda ~",
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.redAccent,
                        fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),

                TextFormField(
                  controller: _Otp,
                  decoration: InputDecoration(
                    hintText: "Enter Otp",
                    labelText: "OTP",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.pin),
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: ElevatedButton(
                      onPressed: () => {
                            verityOtp(),
                            setState(() {
                              _visible = !_visible;
                            })
                          },
                      child: Text("Verity OTP")),
                ),
              ])

              // end PinEntryTextField()
              ), // end Padding()
        ),
      ),
    );
  }
}
