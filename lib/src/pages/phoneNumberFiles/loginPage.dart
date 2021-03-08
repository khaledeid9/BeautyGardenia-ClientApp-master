import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markets/src/pages/phoneNumberFiles/tryLogIn_2.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class LoginScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();  
  final _codeController = TextEditingController();

  String phoneNumber;

  //Place A 
  

//----------------

 Future registerUser(String mobile, BuildContext context) async{

  FirebaseAuth _auth = FirebaseAuth.instance;
  
  _auth.verifyPhoneNumber(
    phoneNumber: mobile,
    timeout: Duration(seconds: 60),
    verificationCompleted: (AuthCredential credential){
      _auth.signInWithCredential(credential).then((UserCredential result)
      {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => HomeScreen(user: result.user)
             ));}).catchError((e){
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
        onPressed: () {
          FirebaseAuth auth = FirebaseAuth.instance;
          
          String smsCode = _codeController.text.trim();
          
          AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          auth.signInWithCredential(credential).then((UserCredential result){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context){
               return HomeScreen(user: result.user);
              }
            ));
          }).catchError((e){
            print(e);
          });
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

  //------------------------------------------------------
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(32),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

                SizedBox(height: 16,),

                // TextFormField(
                //   decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(8)),
                //           borderSide: BorderSide(color: Colors.grey[200])
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(8)),
                //           borderSide: BorderSide(color: Colors.grey[300])
                //       ),
                //       filled: true,
                //       fillColor: Colors.grey[100],
                //       hintText: "Phone Number"

                //   ),
                //   controller: _phoneController,
                // ),

                IntlPhoneField(
                    controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  onChanged: (phone) {
                    print(phone.completeNumber);
                    phoneNumber = phone.completeNumber;
                    
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                SizedBox(height: 16,),

                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[200])
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey[300])
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "Password"

                  ),

                  controller: _passController,
                ),

                SizedBox(height: 16,),

                Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text("Login"),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    onPressed: (){
                      print('----phone number = ($phoneNumber) -------');
                      print('----_phoneController number = (${_phoneController.text.trim()}) -------');
                      
                      //code for sign in
                       final mobile = _phoneController.text.trim();
                        registerUser(phoneNumber, context);
                    },
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}