import 'package:flutter/material.dart';

class AppColors {
  static Color amarelo = Colors.yellow;
  static Color marrom = Colors.brown;
  static Color laranja = Colors.deepOrange;
  static Color cinza = Colors.grey;
  static Color cinzaClaro = Color(0xFFE0E0E0);
  static Color cinzaClaro2 = Colors.grey.shade100;
  static Color branco = Colors.white;
  static Color preto = Colors.black;
  static Color pretoClaro = Colors.black38;
  static String logo = "lib/assets/pblogo.png";
  static String logop = "lib/assets/logo512p.png";
  static String voltar = "lib/assets/voltar.png";

  static bool contraste = false;

  static void mudarContraste(){
    if(contraste == false){
      laranja = Colors.yellow;
      marrom = Colors.yellow;
      cinza = Colors.black;
      cinzaClaro = Colors.black;
      cinzaClaro2 = Colors.black;
      branco = Colors.black;
      preto = Colors.yellow;
      pretoClaro = Colors.yellow;
      logo = "lib/assets/pblogocontraste.png";
      voltar = "lib/assets/voltarcontraste.png";

      contraste = true;
    }
    else{
      laranja = Colors.deepOrange;
      marrom = Colors.brown;
      cinza = Colors.grey;
      cinzaClaro = Color(0xFFE0E0E0);
      cinzaClaro2 = Colors.grey.shade100;
      branco = Colors.white;
      preto = Colors.black;
      pretoClaro = Colors.black38;
      logo = "lib/assets/pblogo.png";
      voltar = "lib/assets/voltar.png";
      
      contraste = false;
    }
  }
}
