import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_ticket/features/pages/connexion.dart';
import 'package:manager_ticket/features/styles/delayAnimation.dart';

class Social extends StatelessWidget {
  const Social({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DelayedAnimation(
                delay: 200,
                child: Container(
                  height: 280,
                  child: Image.asset('assets/icons/Confirmed.png'),
                )),
            DelayedAnimation(
                delay: 400,
                child: Container(
                  height: 190,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Commencer en vous connectant d'abord",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Sauvergarder vos ticket pour une utilisation meilleur',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            DelayedAnimation(
                delay: 600,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 40,
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Connexion()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.all(13)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mail_outline_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                "Email",
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
