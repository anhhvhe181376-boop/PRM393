import 'package:lab5_photo/service/photo_api_service.dart';
import 'package:lab5_photo/service/photo_firebase_service.dart';
import 'package:lab5_photo/service/photo_local_service.dart';

import '../models/photo.dart';


class PhotoRepository {
  final PhotoApiService _apiService;
  final PhotoLocalService _localService;
  final PhotoFirebaseService _firebaseService;

  PhotoRepository({
    PhotoApiService? apiService,
    PhotoLocalService? localService,
    PhotoFirebaseService? firebaseService,
  })  : _apiService = apiService ?? PhotoApiService(),
        _localService = localService ?? PhotoLocalService.instance,
        _firebaseService = firebaseService ?? PhotoFirebaseService();

 
  Future<List<Photo>> fetchPhotos() {
    return _apiService.fetchPhotos();
  }


  Future<List<Photo>> getWishlist() {
    return _localService.getWishlist();
  }

  Future<bool> isFavorite(int id) {
    return _localService.isFavorite(id);
  }


  Future<bool> savePhoto(Photo photo) async {
    await _localService.savePhoto(photo);

    try {
      await _firebaseService.savePhoto(photo);
      return true;
    } catch (_) {
      return false;
    }
  }

  
  Future<bool> deletePhoto(int id) async {
    await _localService.deletePhoto(id);

    try {
      await _firebaseService.deletePhoto(id);
      return true;
    } catch (_) {
      return false;
    }
  }


  Future<void> syncWishlistToFirebase() async {
    final localPhotos = await _localService.getWishlist();
    final remotePhotos = await _firebaseService.getWishlist();

    final localIds = localPhotos.map((photo) => photo.id).toSet();

   
    for (final photo in localPhotos) {
      await _firebaseService.savePhoto(photo);
    }

   
    for (final photo in remotePhotos) {
      if (!localIds.contains(photo.id)) {
        await _firebaseService.deletePhoto(photo.id);
      }
    }
  }
}