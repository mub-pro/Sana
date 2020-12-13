import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _firestore.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Future<QuerySnapshot> getDataWithOrderAndLimit() {
    return ref.orderBy('name', descending: true).limit(3).get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
}
