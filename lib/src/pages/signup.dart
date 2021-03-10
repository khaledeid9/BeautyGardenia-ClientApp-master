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

//facebook provider
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

final _auth = FirebaseAuth.instance;

 Future<void> signOut() async {
  await _auth.signOut();
}

class SignUpWidget extends StatefulWidget {
   
 

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;

  
// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------

// void mobileRegistration()
// {
  
//     String phoneNo;
//     String smsCode;
//     String verificationId;

// }


// ------------------------------------------------------------------------------------



  GoogleSignIn googleAuth = GoogleSignIn();
  // FacebookLogin fbLogin = FacebookLogin();

String usernameText;
String emailText;
String password;

FacebookLogin fbLogin = FacebookLogin();

Future signInFB() async {
  final FacebookLoginResult result = await fbLogin.logIn(["email"]);
  final String token = result.accessToken.token;
  final response = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  final profile = json.decode(response.body);
  var username = profile['name'];
  var email = profile['email'];
  print('my name is $username ************************************');
  print('my email is $email *********************************');
  setUserName(username);
  setUserEmail(email);
   _con.user.name = getUserNameText();
   _con.user.email = getEmailText();
   _con.registerwithFacebook();
  print(profile);
  return profile;
}

//----------------------------------------------------------------------------
//-----------------------------------
 
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print('*/*/*/*/*/*/*/*/*/*/*/*/*/*********${googleUser.email} *******/*/*/*/*/*/*/*/*/****');
    print('*/*/*/*/*/*/*/*/*/*/*/*/*/*********${googleUser.displayName} *******/*/*/*/*/*/*/*/*/****');

   
    setUserEmail(googleUser.email);
    setUserName(googleUser.displayName);

    _con.user.email = getEmailText();
    _con.user.name = getUserNameText();
    _con.registerwithGoogle();

                        print('+++++++++++++ _con.user.email ++++++ ${_con.user.email}');
                        print('+++++++++++++ _con.user.name ++++++ ${_con.user.name}');

    

    print(getEmailText()+' printted Email succesfully here ///////////');
    print(getUserNameText()+' printted Username succesfully here ///////////');

      final back = await FirebaseAuth.instance.signInWithCredential(credential).then((value) => Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2));

    return back;

  }


void signinPhone(String username , String emailtext)
{
    _con.user.name = username;
    _con.user.email = emailText;
    _con.registerwithGoogle();
}


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


// facebook sign in function
  // Future<UserCredential> signInWithFacebook() async {
  // // Trigger the sign-in flow
  // final LoginResult result = await FacebookAuth.instance.login();

  // // Create a credential from the access token
  // final FacebookAuthCredential facebookAuthCredential =
  //   FacebookAuthProvider.credential(result.accessToken.token);

  // // Once signed in, return the UserCredential
  // return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

   
 void loginWithFB() async {

    FacebookAuthCredential facebookAuthCredential ;

   fbLogin.logIn(['email','public_profile']).then((value) {
      switch(value.status) {
        case FacebookLoginStatus.loggedIn:
          facebookAuthCredential = 
          FacebookAuthProvider.credential(value.accessToken.token);
          FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value) {
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          }).catchError((e){print(e);});
      }
   }).catchError((e){
     print(e);
   });

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
  

void checkUser() async {
  try {
         final newUser = await _auth.createUserWithEmailAndPassword(email: getEmailText() , password: getPasswordText() );
                                    if(newUser != null)
                                    {
                                      print('********************** ${_con.user.email} ');
                                      print('print email successfully');
                                      _con.register();
                                      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                                    }

                                  }
                              catch(e)
                              {
                                print('*******//**// $e');
                                print('********************** faild ');

                              }   
                          }


  _SignUpWidgetState() : super(UserController()) {
    

    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
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
              S.of(context).register,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
       
      ),
      ///--------------------------------------------------------------------------
     
     
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body:  ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
            
              
              // Positioned(
              //   top: 0,
              //   child: Container(
              //     width: config.App(context).appWidth(100),
              //     height: config.App(context).appHeight(29.5),
              //     decoration: BoxDecoration(color: Theme.of(context).accentColor),
              //   ),
              // ),
              // Positioned(
              //   top: config.App(context).appHeight(29.5) - 120,
              //   child: Container(
              //     width: config.App(context).appWidth(84),
              //     height: config.App(context).appHeight(29.5),
              //     child: Text(
              //       S.of(context).lets_start_with_register,
              //       style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Theme.of(context).primaryColor)),
              //     ),
              //   ),
              // ),
              child:Container(
               
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
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (input) { 
                          _con.user.email = input;
                          setUserEmail(input);
                        },
                        //validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'johndoe@gmail.com',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        obscureText: _con.hidePassword,
                        onChanged:(input) {
                          _con.user.password = input;
                          password = input;
                          setPassword(input);
                        }, 
                        //buildCounter: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          labelStyle: TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '••••••••••••',
                          hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con.hidePassword = !_con.hidePassword;
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: Text(
                          S.of(context).register,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                              checkUser();
                              
                        },
                      ),


                      ///-------------------------------------------------------------
                      ///------- google button signin --------------------------------
                      SizedBox(height: 25),

                     FlatButton(
                       onPressed: () {
                         signInWithGoogle();
                       },
                       padding: EdgeInsets.symmetric(vertical: 14),
                       color: Theme.of(context).accentColor.withOpacity(0.1),
                       shape: StadiumBorder(),
                       child: Text(
                         S.of(context).signwithGoogle,
                         textAlign: TextAlign.start,
                         style: TextStyle(
                           color: Theme.of(context).accentColor,
                         ),
                       ),
                     ),

                     //--------------------------------------------------
                     //------- facebook button login ---------------------

                      SizedBox(height: 25),

                     FlatButton(
                       onPressed: () async{
                         signInFB().whenComplete(() {
                          
                          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                        });
                       
                       },
                       padding: EdgeInsets.symmetric(vertical: 14),
                       color: Theme.of(context).accentColor.withOpacity(0.1),
                       shape: StadiumBorder(),
                       child: Text(
                         S.of(context).signwithFacebook,
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
        
    
          Container(
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Login');
              },
              textColor: Theme.of(context).hintColor,
              child: Text(S.of(context).i_have_account_back_to_login),
            ),
          ),

            ],
        ),
                 
    
       
    );
  }
}
