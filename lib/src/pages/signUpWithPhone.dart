import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';

// google provider
import 'package:google_sign_in/google_sign_in.dart';

final _auth = FirebaseAuth.instance;

class SignUpWidgetWithPhoneNumber extends StatefulWidget {
   
 

  @override
  _SignUpWidgetWithPhoneNumberState createState() => _SignUpWidgetWithPhoneNumberState();
}

class _SignUpWidgetWithPhoneNumberState extends StateMVC<SignUpWidgetWithPhoneNumber> {
  UserController _con;

  
// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------



// ------------------------------------------------------------------------------------



  GoogleSignIn googleAuth = GoogleSignIn();
  // FacebookLogin fbLogin = FacebookLogin();

String usernameText;
String emailText;
String password;

    String phoneNo;
    String smsCode;
    String verificationId;


//----------------------------------------------------------------------------
//-----------------------------------
 
  Future<void> mobileRegistration() async{
  
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String phoneID){
        this.verificationId = phoneID;
    };

    final PhoneCodeSent smsCodeSent = (String phoneID , [int forceCodeResend])
    {
        this.smsCode = phoneID;
    };

    // final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential)
    // {
    //     print('Completed Verification');
    // };

    await _auth.verifyPhoneNumber(
      phoneNumber: this.phoneNo, 

      verificationCompleted: (PhoneAuthCredential credential) async {
    await _auth.signInWithCredential(credential);
    print('Completed Verification');
  }, 


      verificationFailed: (FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
    // Handle other errors
  },

      codeSent: smsCodeSent,


      timeout: const Duration(seconds: 5), 

      codeAutoRetrievalTimeout: autoRetrievalTimeout,
      
      );


  }


Future<bool> smsCodeDialog (BuildContext context)
{
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context){
      return new AlertDialog(
          title: Text('enter sms Code'),
          content: TextField(onChanged: (input){
            this.smsCode = input;
          }),
          contentPadding: EdgeInsets.all(10),
          actions: <Widget>[
            FlatButton(onPressed: () async{
              final user = await _auth.currentUser;
              if(user != null)
              {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
              }
              else
              {
                Navigator.pop(context);
              }
            }, 
            child: Text('Done'),
            ),
          ],
      );
    }
  
  );

}

// void signInWithPhoneNumber() async {
//   try {
//     final AuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: smsCode,
//     );

//     final User user = (await _auth.signInWithCredential(credential)).user;
    
//     print("Successfully signed in UID: ${user.uid}");
    
//   } catch (e) {
//     print("Failed to sign in: " + e.toString());
//   }
// }



void setUserName( String username)
{
    usernameText = username;
    _con.user.name = username;

}

void setUserEmail(String email )
{
  emailText = email;
  _con.user.email = email;
}

void setPassword(String pass)
{
    password = pass;
    _con.user.password = pass;
}

String getEmailText()
    {
      if(emailText != null )
      {
        return emailText;
      }
      else
      return 'Empty Email';
    }

    String getUserNameText()
    {
      if(usernameText != null )
      {
          return usernameText;
      }
      else
      {
        return 'Empty Username';
      }
    }

String getPasswordText()
    {
      if(password != null )
      {
          return password; 
      }
      else
      {
        return 'Empty password';
      }
    }




  void printFunction(String name , String email , String password)
  {
    print('///////// print function here /////////');
    print('///////// {$name} print function here /////////');
    print('///////// {$email} print function here /////////');
    print('///////// {$password} print function here /////////');

  }

//--------------------------------------------------------------------------
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------






////------------------------------------------------------------------------------------------------------------------------


  _SignUpWidgetWithPhoneNumberState() : super(UserController()) {
    

    _con = controller;
  }
  @override
  Widget build(BuildContext context) {

    String emailNumber = '@beautyGardenia.com';

    return Scaffold(
        ////-------------------------------------------------------------------------
      
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Theme.of(context).hintColor),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          }
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
              'Registration',
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
       
      ),
      ///--------------------------------------------------------------------------
     
     
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(29.5),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(29.5) - 120,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(29.5),
                child: Text(
                  S.of(context).lets_start_with_register,
                  style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(29.5) - 50,
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
                  BoxShadow(
                    blurRadius: 50,
                    color: Theme.of(context).hintColor.withOpacity(0.2),
                  )
                ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                child: Form(
                  key: _con.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: (input) { 
                          _con.user.name = input;
                          setUserName(input);
                          setUserEmail(input+emailNumber); 
                          _con.user.email = getEmailText();
                          print('----- your phone number is ${_con.user.name}  --------- ');
                          print('----- your Email with phone number is ${_con.user.email}  --------- ');
                          },

                        //validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).full_name,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: S.of(context).john_doe,
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.person_outline, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        ),
                      ),
                      
                      
                      SizedBox(height: 30),
                      

                      SizedBox(height: 30),
                      


                      ///-------------------------------------------------------------
                      ///------- google button signin --------------------------------
                      SizedBox(height: 25),

                     FlatButton(
                       onPressed: () {
                         mobileRegistration();
                       },
                       padding: EdgeInsets.symmetric(vertical: 14),
                       color: Theme.of(context).accentColor.withOpacity(0.1),
                       shape: StadiumBorder(),
                       child: Text(
                         'Login with Phone Number',
                         textAlign: TextAlign.start,
                         style: TextStyle(
                           color: Theme.of(context).accentColor,
                         ),
                       ),
                     ),

                    

                     

                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Login');
                },
                textColor: Theme.of(context).hintColor,
                child: Text(S.of(context).i_have_account_back_to_login),
              ),
            )
          ],
        ),
    
    );
  }
}
