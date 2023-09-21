import 'package:chatapp/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

 String email = "";
 final _formkey = GlobalKey<FormState>();

  TextEditingController usermailcontroller = new TextEditingController();
  
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Password Reset Email has been sent",
        style: TextStyle(fontSize: 18.0),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "No User found for that email.",
          style: TextStyle(fontSize: 18.0),
        )));
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        
        child: Stack(
          children: [
           Container(
            height: MediaQuery.of(context).size.height/4.0,
            width: MediaQuery.of(context).size.width, 


            decoration: BoxDecoration(
              gradient: LinearGradient(colors:[Color(0xFF7f40fe),Color(0xFF6380fb)],begin: Alignment.topLeft,end: Alignment.bottomRight ),
              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0))
            ),
           ),

           Padding(
             padding: const EdgeInsets.only(top: 60.0),
             child: Column(children: [
              Center(child: Text("Password Recovery",style: TextStyle(color: Colors.white,fontSize: 25.0,fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 10,
              ),
               Center(child: Text("Enter your email",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w400),
              )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:20.0,vertical: 30.0 ),
                    height: MediaQuery.of(context).size.height/2.4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(10),
                     ),
                     child: Form(
                      key: _formkey,
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                     
                        children: [
                          const Text("Email",style: TextStyle(color: Colors.black,fontSize:18.0 ,fontWeight: FontWeight.w500
                          ),),
                          SizedBox(height: 10,),
                          Container(padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black38)
                     
                          ),
                            child: TextFormField(
                            controller: usermailcontroller,
                            validator: (value){
                              if(value ==null ||value.isEmpty){
                                return "please Enter E-mail";
                              }
                              return null;


                            },

                          decoration: InputDecoration(border: InputBorder.none,
                          prefixIcon: Icon(Icons.mail_outline_outlined,color: Color(0xFF7f40fe),)
                          ),
                          ),),
                          SizedBox(height: 60,),
                     
                             
                         
                          
                           GestureDetector(
                            onTap: (){
                            if(_formkey.currentState!.validate()){
                                    setState(() {
                                      email= usermailcontroller.text;
                                    });
                                    resetPassword();
                                  }
                            },
                             child: Center(
                               child: Container(
                                width: 100,
                                 child: Material(
                                  elevation: 5.0,
                                   child: Center(
                                     child: Container(
                                      
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: Color(0xFF6380fb),borderRadius: BorderRadius.circular(10)),
                                      child: Center(child: Text("Reset",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),),
                                   ),
                                 ),
                               ),
                             ),
                           )
                        ],
                       ),
                     ),
                  ),
                  
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Don't have an account ?",style: TextStyle(color: Colors.black,fontSize: 16),),
                GestureDetector(
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                  },
                  child: Text(" SignUp ",style: TextStyle(color:Color(0xFF7f30fe),fontSize: 16,fontWeight: FontWeight.w500),))
              ],)
              
             ],),
           )
          ],
        ),
      ),
    );
  }
}