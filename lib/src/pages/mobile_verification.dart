import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;

//---------------------------------------------------------


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../pages/signup.dart';


String emailAccount='beautygardenia@gmail.com';
String nameAccount;
String email;
String countryCode = '+962';

class MobileVerification extends StatefulWidget {

  @override
  _MobileVerificationState createState() => _MobileVerificationState();
}

//-----------------------------------------------------------------------------------

FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<void> signOut_mobile() async {
  await _auth.signOut();
}

//-----------------------------------------------------------------------------------

class _MobileVerificationState extends StateMVC<MobileVerification> {
  
  UserController _con;
  SignUpWidget signobj;

  

 final _phoneController = TextEditingController();
  final _passController = TextEditingController();  
  final _codeController = TextEditingController();

  String phoneNumber;

  //Place A 
  
  

//----------------

 Future registerUser(String mobile, BuildContext context) async{


  _auth.verifyPhoneNumber(
   
    phoneNumber: mobile,
    timeout: Duration(seconds: 60),
    verificationCompleted: (AuthCredential credential){
      _auth.signInWithCredential(credential).then((UserCredential result)
      {
         print('--///////////-- verificationCompleted = () ----//////////////---');
      //  _con.user.name = phoneNumber;
      //                 _con.user.email = phoneNumber+'beautygardenia.com@gmail.com';
      //                   print('--///////////-- _con.user.name = (${ _con.user.name}) ----//////////////---');
      //                   print('-////////---_con.user.email = (${_con.user.email}) ---///////////----');
      //     _con.registerwithGoogle();
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
             }).catchError((e){
            print(e);
          });
          },

          verificationFailed: (FirebaseAuthException authException){
           print(authException.message);
          },

//---------------------------------

    codeSent: (String verificationId, [int forceResendingToken]){
  //show dialog to take input from the user
  showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    title: Text("Enter SMS Code"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _codeController,
        ),

      ],
    ),
    actions: <Widget>[
      FlatButton(
        child: Text("Done"),
        textColor: Colors.white,
        color: Colors.redAccent,
        onPressed: () async{
          FirebaseAuth auth = FirebaseAuth.instance;
          
          String smsCode = _codeController.text.trim();
          
          AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

          
         auth.signInWithCredential(credential).then((UserCredential result){
                      _con.user.name = phoneNumber;
                      _con.user.email ='beautygardenia@gmail.com';
                        print('--///////////-- _con.user.name = (${ _con.user.name}) ----//////////////---');
                        print('-////////---_con.user.email = (${_con.user.email}) ---///////////----');
                _con.registerwithPhoneNumber();
          },
          
          ).catchError((e){
            print(e);
          });      
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        },
      )
    ],
  )
);},

    //--------------------------------------------

    codeAutoRetrievalTimeout: (String verificationId){
      verificationId = verificationId;
      print(verificationId);
      print("---- Timout -----");
    },

    //-------------------------------------
  );
 
  } 

_MobileVerificationState() : super(UserController()) {
    _con = controller;
  }


  @override
  Widget build(BuildContext context) {
    final _ac = config.App(context);
    return Scaffold(
      key: _con.scaffoldKey,
      body: ListView(
        children:[
              Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
             key: _con.loginFormKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: _ac.appWidth(100),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Verify Phone ',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Your phone and address book are used to connect. Call you to verify your phone Number',
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                IntlPhoneField(
                      controller: _phoneController,
                    textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2)),
                    ),
                    focusedBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.7),
                      ),
                    ),
                    hintText: 'xxx-xxx-xxx',
                   hintStyle: TextStyle(color: Colors.grey),
                  ),
                    onChanged: (phone) {
                      print(phone.completeNumber);
                      phoneNumber = phone.completeNumber;
                      
                    },
                  ),
                SizedBox(height: 30),

                // TextField(
                //   onChanged: (value){
                //     print('---------($value)-------------');
                //     nameAccount = value;
                //     email = value;
                    
                //   },
                  
                //   keyboardType: TextInputType.phone,
                //   textAlign: TextAlign.center,
                //   decoration: InputDecoration(
                    
                //     enabledBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2)),
                //     ),
                //     focusedBorder: new UnderlineInputBorder(
                //       borderSide: new BorderSide(
                //         color: Theme.of(context).focusColor.withOpacity(0.7),
                //       ),
                //     ),
                //     hintText: '+962 xxx-xxx-xxxx',
                //    hintStyle: TextStyle(color: Colors.grey),
                //   ),
                // ),

                SizedBox(height: 40),

                // TextFormField(
                //           keyboardType: TextInputType.text,
                //           onSaved: (input) => _con.user.password = input,
                //           validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                //           obscureText: _con.hidePassword,
                //           controller: _passController,
                //           decoration: InputDecoration(
                //             labelText: S.of(context).password,
                //             labelStyle: TextStyle(color: Theme.of(context).accentColor),
                //             contentPadding: EdgeInsets.all(12),
                //             hintText: '••••••••••••',
                //             hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                //             prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                //             suffixIcon: IconButton(
                //               onPressed: () {
                //                 setState(() {
                //                   _con.hidePassword = !_con.hidePassword;
                //                 });
                //               },
                //               color: Theme.of(context).focusColor,
                //               icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                //             ),
                //             border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                //             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                //             enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                //           ),
                //         ),
                        SizedBox(height: 30),

                BlockButtonWidget(
                  onPressed: () async {

                       print('----phone number = ($phoneNumber) -------');
                        print('----_phoneController number = (${_phoneController.text.trim()}) -------');
                        
                        _con.user.name = phoneNumber;
                        _con.user.email ='beautygardenia.com@gmail.com';
                        
                         print('---- _con.user.name = (${ _con.user.name}) -------');
                        print('----_con.user.email = (${_con.user.email}) -------');

                        //code for sign in
                        // final mobile = _phoneController.text.trim();
                          await registerUser(phoneNumber, context);

                         // _con.registerwithGoogle();
                       // _con.registerwithPhoneNumber();

                    // nameAccount = '+962'+nameAccount;
                    // print('---name Account-------(${nameAccount}) -----------');
                    // mobileRegistration();
                    // if(signing == true)
                    // {
                    //   _con.user.email = email;
                    //   _con.user.name = nameAccount;
                    //   _con.registerwithPhoneNumber();
                    //   Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                    // }
                   // Navigator.of(context).pushNamed('/MobileVerification2');
                  },

                  color: Theme.of(context).accentColor,
                  text: Text('SEND Verification CODE',
                      style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor))),
                ),

                SizedBox(height: 50),


                // TextField(
                //   style: Theme.of(context).textTheme.headline5,
                //   textAlign: TextAlign.center,
                //   decoration: new InputDecoration(
                //     enabledBorder: UnderlineInputBorder(
                //       borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2)),
                //     ),
                //     focusedBorder: new UnderlineInputBorder(
                //       borderSide: new BorderSide(
                //         color: Theme.of(context).focusColor.withOpacity(0.5),
                //       ),
                //     ),
                //     hintText: '000-000',
                //      hintStyle: TextStyle(color: Colors.grey , fontSize: 18),
                //   ),
                // ),

                // BlockButtonWidget(
                //   onPressed: () async {
                //    signInWithPhoneNumber();
                //    // Navigator.of(context).pushNamed('/MobileVerification2');
                //   },
                //   color: Theme.of(context).accentColor,
                //   text: Text(S.of(context).submit.toUpperCase(),
                //       style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).primaryColor))),
                // ),

              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
