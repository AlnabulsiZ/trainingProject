import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:tasheha_app/pages/normal_user.dart';
import 'package:tasheha_app/pages/owner.dart';
import 'package:tasheha_app/pages/guide.dart';
class RegisterOption extends StatefulWidget {
  const RegisterOption({super.key});

  @override
  State<RegisterOption> createState() => _RegisterOptionState();
}

class _RegisterOptionState extends State<RegisterOption> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text('Register page', style: TextStyle(color: AppColors.blueC, fontSize: 35,fontFamily: 'RadioCanadaBig',)),
              const SizedBox(height: 15),
              Text('Join us as', style: TextStyle(color: AppColors.brownC, fontSize: 18,fontFamily: 'RadioCanadaBig',)),
              const SizedBox(height: 50),
               GestureDetector( onTap:(){
                setState(() {
                  _isExpanded1 = !_isExpanded1; 
                });

               },
               child: Row(
                
                children: [
                   const SizedBox(width: 15,),
                   Icon(
                    _isExpanded1 ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.blueC,
                  ),
                  const SizedBox(width: 5,),
                   Text(
                    "normal user",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.blueC,
                      fontFamily: 'RadioCanadaBig',
                    ),
                  ),
                ],
               ),),
               if (_isExpanded1)
              Padding(
                padding: const EdgeInsets.only(top:15,left: 15),
                child:
                  Text(
                  "You can join us to explore tourist attractions and guides, as well as discover unique places for an enjoyable time",
                  style: TextStyle(fontSize: 15),
                ),
              ),                              

               const SizedBox(height: 15,),

               GestureDetector( onTap:(){
                setState(() {
                  _isExpanded2 = !_isExpanded2; 
                });

               },
               child: Row(
                
                children: [
                   const SizedBox(width: 15,),
                   Icon(
                    _isExpanded2 ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.blueC,
                  ),
                  const SizedBox(width: 5,),
                   Text(
                    "Place owner",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.blueC,
                      fontFamily: 'RadioCanadaBig',
                    ),
                  ),
                ],
               ),),
              if (_isExpanded2)
              Padding(
                padding: const EdgeInsets.only(top:15,left: 15),
                child: Text(
                  "If you own a place, you can now add it to the app, allowing users to discover its details and the services you provide",
                  style: TextStyle(fontSize: 15),
                ),
              ),               
               const SizedBox(height: 15,),

               GestureDetector( onTap:(){
                setState(() {
                  _isExpanded3 = !_isExpanded3; 
                });

               },
               child: Row(
                
                children: [
                   const SizedBox(width: 15,),
                   Icon(
                    _isExpanded3 ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.blueC,
                  ),
                  const SizedBox(width: 5,),
                   Text(
                    "Tourist guide or camping guide",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.blueC,
                      fontFamily: 'RadioCanadaBig',
                    ),
                  ),
                ],
               ),),
              if (_isExpanded3)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "If you're an adventurer who organizes camping trips\nor a tour guide, you can now join us, allowing users to connect with you and learn more about your trips",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 25,),
              Padding(
                padding: EdgeInsets.all(15),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:(){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NormalUser()),
                      );
                    },
                    child: Text('user',style: TextStyle(fontSize: 15),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownC,
                      foregroundColor: AppColors.backC,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed:(){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Owner()),
                      );
                    },
                    child: Text('owner',style: TextStyle(fontSize: 15),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownC,
                      foregroundColor: AppColors.backC,
                    ),
                  ),                  
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed:(){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Guide()),
                      );
                    },
                    child: Text('Guide',style: TextStyle(fontSize: 15),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brownC,
                      foregroundColor: AppColors.backC,
                    ),
                  ),
                ],
              ) ,
             ),
            ],
          ),
        ),
      ),
    );
  }
}