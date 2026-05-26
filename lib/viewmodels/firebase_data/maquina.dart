import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> pegarId() async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("Usuário não está logado");
    return null;
  }

  final uid = user.uid;

  final idconex = await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(uid)
      .get();

  if (!idconex.exists) return null;

  final userData = idconex.data() as Map<String, dynamic>;

  return userData['idSensor'] as String?;
}

Future<String?> lerNomeMaquina() async {
  final idSensor = await pegarId();

  final snapshot = await FirebaseFirestore.instance
      .collection('Sensor')
      .doc(idSensor)
      .get();

  if (!snapshot.exists) return null;

  final dados = snapshot.data() as Map<String, dynamic>;
  return dados['NomeSensor'] as String?;
}

Future<bool?> lerEstadoMaquina() async {
  final idSensor = await pegarId();
  
  final snapshot = await FirebaseFirestore.instance
      .collection('Sensor')
      .doc(idSensor)
      .get();

  if (!snapshot.exists) return null;

  final dados = snapshot.data() as Map<String, dynamic>;
  return dados['Operando'] as bool?;
}

Stream<String?> streamNomeMaquina() {
  return Stream.fromFuture(pegarId()).asyncExpand((idSensor) {
    if (idSensor == null) return Stream.value(null);

    return FirebaseFirestore.instance
        .collection('Sensor')
        .doc(idSensor)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          final dados = snapshot.data() as Map<String, dynamic>;
          return dados['NomeSensor'] as String?;
        });
  });
}

Stream<bool?> streamEstadoMaquina() {
  return Stream.fromFuture(pegarId()).asyncExpand((idSensor) {
    if (idSensor == null) return Stream.value(null);

    return FirebaseFirestore.instance
        .collection('Sensor')
        .doc(idSensor)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          final dados = snapshot.data() as Map<String, dynamic>;
          return dados['Operando'] as bool?;
        });
  });
}