

import 'package:chatapp/pages/home.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/services/shared_preference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChatPage extends StatefulWidget {
  String name,username,profileurl;
  ChatPage({
   required this.name,
   required this.profileurl,
   required this.username

  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = new TextEditingController();
  
  String? myName , myProfilePic , myUserName,myEmail,messageId,chatRoomId;
  Stream? messageStream;
  
  getTheSharedPref()async{
  myName = await SharedPreferenceHelper().getDisplayName();
   myProfilePic = await SharedPreferenceHelper().getUserPic();
   myUserName = await SharedPreferenceHelper().getUserName();
   myEmail = await SharedPreferenceHelper().getUserEmail();

   chatRoomId = getChatRoomIdbyUsername(widget.username, myUserName!);
   setState(() {
     
   });
   

}

onTheLoad()async{
  await getTheSharedPref();
  await getAndSetMessages();
  setState(() {
    
  });
}

@override
void initState(){
  super.initState();
  onTheLoad();
}

getChatRoomIdbyUsername(String a,String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
  return  "$a\_$b";
}
}

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0)),
              color: sendByMe
                  ? Color.fromARGB(255, 234, 236, 240)
                  : Color.fromARGB(255, 211, 228, 243)),
          child: Text(
            message,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
        )),
      ],
    );
  }

Widget chatMessage(){
  return StreamBuilder(
     stream: messageStream  ,
     builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData?ListView.builder(
        padding: EdgeInsets.only(bottom: 90.0,top: 130),
        itemCount: snapshot.data.docs.length,
        reverse: true,
        itemBuilder: (context,index){
        DocumentSnapshot ds = snapshot.data.docs[index];
        return  chatMessageTile(
                        ds["message"], myUserName == ds["sendBy"]);
        }):Center(
                  child: CircularProgressIndicator(),
                );

     });
}


  addMessage(bool sendClick){
    if(messageController.text!=""){
      String message =messageController.text;
      messageController.text="";
    
      DateTime now =  DateTime.now();
      String formatedDate = DateFormat('h:mma').format(now);

      Map<String, dynamic>messageInfoMap = {
        "message":message,
        "sendBy": myUserName,
        "ts": formatedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic
      };
    
        messageId ??= randomAlphaNumeric(10);
       

      DatabaseMethods().addMessage(chatRoomId!, messageId!, messageInfoMap).then((value) {
        Map<String,dynamic>lastMessageInfo = {
          "lastMessage":message,
          "lastMessageSendTs": formatedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName
        };

         DatabaseMethods().updateLastMessageSend(chatRoomId!, lastMessageInfo);
         if(sendClick){
          messageId=null;
         }
      });
    }
  }

    getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: Container(
        padding: EdgeInsets.only(top: 60),
       child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.3,
            decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30))),
            
            child: chatMessage()),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0Xffc199cd),
                  ),
                ),
                SizedBox(
                  width: 110,
                ),
                 Text(widget.name,style: TextStyle(
                color: Color(0Xffc199cd),fontSize: 20,fontWeight: FontWeight.w500
              ),),
              ],
            ),
          ),
         
              Container(
                 margin:EdgeInsets.only(left: 20,right: 20,bottom: 20) ,
                alignment: Alignment.bottomCenter,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 5.0,
                  child: Container(
                   
                    padding: EdgeInsets.only(left: 14),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                    child:  TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.black45,),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                
                                addMessage(true);
                              },
                              child: Icon(Icons.send_rounded))
                          ),
                        ),
                      ),
                     
                    
                  ),
                
              )
            ],
          ),
          
          ),
        
       
       
    );

  }
}