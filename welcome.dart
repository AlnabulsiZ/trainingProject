import 'package:flutter/material.dart';
import 'package:tasheha_app/Theme/colors.dart';
import 'package:tasheha_app/pages/login.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/welcome_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
//background image
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 90),
                const Text(
                  "Let's\nenjoy the\nbeauty of\nJordan",
                  style: TextStyle(
                    fontFamily: 'RadioCanadaBig',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Some places are more than just locations - explore, have fun, and make memories.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
 //Texts
          Padding(padding: EdgeInsets.only(left: 35,bottom: 35),
          child:Align(
            alignment: Alignment.bottomLeft,
            child:GestureDetector(
           onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()), 
            );
             },
                child: Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: AppColors.backC,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_right_alt,
                                color: AppColors.blueC,
                                size: 45,
                              ),
                            ),
                          ),
                  ), ), )
//next icon 
               
        ],
      ),
    );
  }
}