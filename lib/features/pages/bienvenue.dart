import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:manager_ticket/features/styles/delayAnimation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'social.dart';

class Bienvenue extends StatelessWidget {
  const Bienvenue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
          child: Column(
            children: [
              DelayedAnimation(
                  child: Container(
                    height: 90,
                    child: Image.asset('assets/icons/Logo.png'),
                  ),
                  delay: 200),
              const Gap(10),
              DelayedAnimation(
                  child: Container(
                    height: 450,
                    child: Image.asset('assets/icons/welcome.png'),
                  ),
                  delay: 400),
              const Gap(10),
              DelayedAnimation(
                  child: Container(
                    child: Text(
                      "Votre meilleur gestionnaire de Ticket",
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  delay: 600),
              const Gap(30),
              DelayedAnimation(
                  child: Container(
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Social()));
                          },
                          child: Text(
                            "C'est partie :) !",
                            style: GoogleFonts.poppins(color: Colors.white),
                          )),
                    ),
                  ),
                  delay: 800),
            ],
          ),
        ),
      ),
    );
  }
}
