import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/photo.dart';

class PhotoFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Các thao tác đồng thời sẽ chờ chung một lần đăng nhập.
  Future<User>? _signInFuture;

  Future<User> _getUser() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      return currentUser;
    }

    return _signInFuture ??= _signInAnonymously();
  }

  Future<User> _signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;

      if (user == null) {
        throw StateError('Không tạo được người dùng Firebase.');
      }

      return user;
    } finally {
      // Cho phép thử lại nếu đăng nhập lỗi.
      _signInFuture = null;
    }
  }

  // Trả về collection Photo thuộc người dùng hiện tại.
  Future<CollectionReference<Map<String, dynamic>>>
      _getPhotoCollection() async {
    final user = await _getUser();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('photos');
  }

  // Lưu Photo lên Firestore.
  Future<void> savePhoto(Photo photo) async {
    final collection = await _getPhotoCollection();

    await collection
        .doc(photo.id.toString())
        .set(photo.toMap());
  }

  // Đọc danh sách Photo đã quan tâm trên Firestore.
  Future<List<Photo>> getWishlist() async {
    final collection = await _getPhotoCollection();

    final snapshot = await collection
        .orderBy('id', descending: true)
        .get();

    return snapshot.docs
        .map((document) => Photo.fromMap(document.data()))
        .toList();
  }

  // Xóa Photo khỏi Firestore.
  Future<void> deletePhoto(int id) async {
    final collection = await _getPhotoCollection();

    await collection.doc(id.toString()).delete();
  }
}