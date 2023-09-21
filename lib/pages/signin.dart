import 'package:chatapp/pages/home.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/shared_preference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email = "",password = "",name = "",pic = "",username = "", id = "";
  TextEditingController usermailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();
  
 final _formkey = GlobalKey<FormState>();

  userLogin()async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     
     QuerySnapshot querySnapshot = await DatabaseMethods().getUserbyemail(email);
       name = "${querySnapshot.docs[0]["Name"]}";
       username = "${querySnapshot.docs[0]["username"]}";
       pic = "${querySnapshot.docs[0]["Photo"]}";
       id = "${querySnapshot.docs[0].id}";

       await SharedPreferenceHelper().saveUserDisplayName(name);
       await SharedPreferenceHelper().saveUserDisplayName(username);
       await SharedPreferenceHelper().saveUserDisplayName(id);
       await SharedPreferenceHelper().saveUserDisplayName(pic);
      


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
    }on FirebaseAuthException  catch(e){
       if(e.code =="user-not-found"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent,content:Text("No user found for that email",style: TextStyle(fontSize: 18,color: Colors.black),)));
      }
      else if(e.code == 'wrong-password'){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent,content:Text("Wrong password",style: TextStyle(fontSize: 18,color: Colors.black),)));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
              Center(child: Text("SignIn",style: TextStyle(color: Colors.white,fontSize: 25.0,fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 10,
              ),
               Center(child: Text("Login to your account",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w400),
              )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:20.0,vertical: 30.0 ),
                    height: MediaQuery.of(context).size.height/1.9,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(10),
                     ),
                     child: Form(
                      key:_formkey,
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
                          SizedBox(height: 20,),
                     
                            const Text("Password",style: TextStyle(color: Colors.black,fontSize:18.0 ,fontWeight: FontWeight.w500
                          ),),
                          SizedBox(height: 10,),
                          Container(padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black38)
                     
                          ),
                            child: TextFormField(
                              controller: userpasswordcontroller,
                            validator: (value){
                              if(value ==null ||value.isEmpty){
                                return "please Enter password";
                              }
                              return null;


                            },
                          decoration: InputDecoration(border: InputBorder.none,
                          prefixIcon: Icon(Icons.password_outlined,color: Color(0xFF7f40fe),)
                          ),
                          obscureText: true,
                          ),),
                          SizedBox(height: 10,),
                           Container(
                            alignment: Alignment.bottomRight,
                             child: Text("Forgot Password?",style: TextStyle(color: Colors.black,fontSize:16.0 ,fontWeight: FontWeight.w500
                                                   ),),
                           ),SizedBox(height: 20,),
                           GestureDetector(
                            onTap: (){
                              if(_formkey.currentState!.validate()){
                                setState(() {
                                  
                                  email = usermailcontroller.text;
                                  password = usermailcontroller.text;
                                });
                              }
                              userLogin();
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
                                      child: Center(child: Text("SignIn",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),),
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
                Text(" SignUp ",style: TextStyle(color:Color(0xFF7f30fe),fontSize: 16,fontWeight: FontWeight.w500),)
              ],)
              
             ],),
           )
          ],
        ),
      ),
    );
  }
}