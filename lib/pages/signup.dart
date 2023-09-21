import 'package:chatapp/pages/home.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/shared_preference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  String email = "",password = "",name = "", confirmPassword = "";
  TextEditingController mailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
 
  final _formkey = GlobalKey<FormState>();

  registration()async{
  if(password !=null  && password == confirmPassword){
    try{
    UserCredential userCredential  = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
     
   String Id = randomAlphaNumeric(10);
    String user=mailController.text.replaceAll("@gmail.com", "");
        String updateusername= user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter= user.substring(0,1).toUpperCase();



   Map<String,dynamic>userInfoMap ={
    "Name":nameController.text,
    "E-mail": mailController.text,
    "username":updateusername.toUpperCase(),
     "SearchKey": firstletter,
     "Photo": "https://plus.unsplash.com/premium_photo-1669029181733-f88dbb8451d9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW5zdGFncmFtJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=1000&q=60",
     "Id": Id, 
   };

  await DatabaseMethods().addUserDetail(userInfoMap, Id);
  await SharedPreferenceHelper().saveUserId(Id);
  await SharedPreferenceHelper().saveUserDisplayName(nameController.text);
  await SharedPreferenceHelper().saveUserEmail(mailController.text);
  await SharedPreferenceHelper().saveUserPic("https://plus.unsplash.com/premium_photo-1669029181733-f88dbb8451d9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW5zdGFncmFtJTIwcHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=1000&q=60");
  await SharedPreferenceHelper().saveUserName(mailController.text.replaceAll("@gmail.com", "").toUpperCase());

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration successfull",style: TextStyle(fontSize: 20),)));


  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));


    }on FirebaseAuthException  catch(e){
      if(e.code =="weak-password"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent,content: Text("password provided is to weak",style: TextStyle(fontSize: 18),)));
      }else if(e.code =="email-already-in-use"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
        
        (backgroundColor: Colors.orangeAccent,
          
          content: Text("Account already exist",style: TextStyle(fontSize: 18),)));
      }
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
              Center(child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 25.0,fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 10,
              ),
               Center(child: Text("Create a new account",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w400),
              )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:20.0,vertical: 20.0 ),
                    height: MediaQuery.of(context).size.height/1.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white,borderRadius:BorderRadius.circular(10),
                     ),
                     child: Form(
                      key: _formkey,
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                     
                        children: [
                           const Text("Name",style: TextStyle(color: Colors.black,fontSize:15.0 ,fontWeight: FontWeight.w500
                          ),),
                          SizedBox(height: 8,),
                          Container(padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black38)
                     
                          ),
                            child: TextFormField(
                              controller: nameController,
                              validator: (value){
                                if(value == null ||value.isEmpty){
                                  return "Please enter name";
                                }
                                return null;
                              },
                          decoration: InputDecoration(border: InputBorder.none,
                          prefixIcon: Icon(Icons.person_2_outlined,color: Color(0xFF7f40fe),)
                          ),
                          ),),
                          SizedBox(height: 10,),
                          const Text("Email",style: TextStyle(color: Colors.black,fontSize:15.0 ,fontWeight: FontWeight.w500
                          ),),
                          SizedBox(height: 8,),
                          Container(padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black38)
                     
                          ),
                            child: TextFormField(
                              controller: mailController,
                               validator: (value){
                                if(value == null ||value.isEmpty){
                                  return "Please enter email";
                                }
                                return null;
                              },
                          decoration: InputDecoration(border: InputBorder.none,
                          prefixIcon: Icon(Icons.mail_outline_outlined,color: Color(0xFF7f40fe),)
                          ),
                          ),),
                          SizedBox(height: 10,),
                     
                            const Text("Password",style: TextStyle(color: Colors.black,fontSize:15.0 ,fontWeight: FontWeight.w500
                          ),),
                          SizedBox(height: 8,),
                          
                          Container(padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black38)
                     
                          ),
                            child: TextFormField(
                              controller: passwordController,
                               validator: (value){
                                if(value == null ||value.isEmpty){
                                  return "Please enter a strong password";
                                }
                                return null;
                              },
                          decoration: InputDecoration(border: InputBorder.none,
                          prefixIcon: Icon(Icons.password_outlined,color: Color(0xFF7f40fe),)
                          ),
                          obscureText: true,
                          ),),
                         SizedBox(height: 10,),
                         const Text("Confirm Password",style: TextStyle(color: Colors.black,fontSize:15.0 ,fontWeight: FontWeight.w500
                          ),),
                          SizedBox(height: 8,),
                          
                          Container(padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(border: Border.all(width: 1.0,color: Colors.black38)
                     
                          ),
                            child: TextFormField(
                              controller: confirmPasswordController,
                               validator: (value){
                                if(value == null ||value.isEmpty){
                                  return "Please cofirm password";
                                }
                                return null;
                              },
                          decoration: InputDecoration(border: InputBorder.none,
                          prefixIcon: Icon(Icons.password_outlined,color: Color(0xFF7f40fe),)
                          ),
                          obscureText: true,
                          ),),
                         //SizedBox(height: 15,),
                         
                        ],
                       ),
                     ),
                  ),
                  
                ),
              ),
              SizedBox(height: 10,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //   Text("Don't have an account ?",style: TextStyle(color: Colors.black,fontSize: 16),),
              //   Text(" SignUp ",style: TextStyle(color:Color(0xFF7f30fe),fontSize: 16,fontWeight: FontWeight.w500),)
              // ],)
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        email = mailController.text;
                        name = nameController.text;
                        password = passwordController.text;
                        confirmPassword = confirmPasswordController.text;
                      });
                    }
                    registration();
                  },
                  child: Center(
                             child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              width:  MediaQuery.of(context).size.width,
                               child: Material(
                                elevation: 5.0,
                                 child: Center(
                                   child: Container(
                                    
                                    padding: EdgeInsets.all(10),
                                    
                                    decoration: BoxDecoration(color: Color(0xFF6380fb),borderRadius: BorderRadius.circular(10)),
                                    child: Center(child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),),
                                 ),
                               ),
                             ),
                           ),
                )
              
             ],),
           )
          ],
        ),
      ),
    );
  }
 
}