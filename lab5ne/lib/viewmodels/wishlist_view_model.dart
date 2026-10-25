import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/photo.dart';
import 'photo_view_model.dart';

part 'wishlist_view_model.g.dart';

// Dữ liệu trạng thái để giao diện theo dõi.
class WishlistState {
  final List<Photo> photos;
  final bool isBusy;
  final String? message;

  WishlistState({
    required List<Photo> photos,
    this.isBusy = false,
    this.message,
  }) : photos = List.unmodifiable(photos);

  bool contains(int photoId) {
    return photos.any((photo) => photo.id == photoId);
  }
}

@Riverpod(keepAlive: true)
class WishlistViewModel extends _$WishlistViewModel {
  @override
  Future<WishlistState> build() async {
    final repository = ref.watch(photoRepositoryProvider);
    final photos = await repository.getWishlist();

    return WishlistState(photos: photos);
  }

  // Đổi trạng thái quan tâm của một Photo.
  Future<void> toggle(Photo photo) async {
    final current = state.asData?.value;

    // Chờ tải xong và không chạy nhiều thao tác cùng lúc.
    if (state.isLoading || current == null || current.isBusy) {
      return;
    }

    final repository = ref.read(photoRepositoryProvider);
    final wasFavorite = current.contains(photo.id);

    state = AsyncData(
      WishlistState(
        photos: current.photos,
        isBusy: true,
      ),
    );

    try {
      final bool synced;

      if (wasFavorite) {
        synced = await repository.deletePhoto(photo.id);
      } else {
        synced = await repository.savePhoto(photo);
      }

      // Repository đã ghi SQLite thành công.
      final updated = [...current.photos];

      if (wasFavorite) {
        updated.removeWhere((item) => item.id == photo.id);
      } else {
        updated.add(photo);
        updated.sort((a, b) => b.id.compareTo(a.id));
      }

      final action = wasFavorite
          ? 'Đã bỏ quan tâm.'
          : 'Đã thêm vào danh sách quan tâm.';

      state = AsyncData(
        WishlistState(
          photos: updated,
          message: synced
              ? '$action Đã đồng bộ Firebase.'
              : '$action Đã lưu trên máy, chưa đồng bộ được Firebase.',
        ),
      );
    } catch (error) {
      // Repository ném lỗi nếu thao tác SQLite thất bại.
      // Giữ nguyên danh sách trước thao tác.
      state = AsyncData(
        WishlistState(
          photos: current.photos,
          message: 'Không cập nhật được WishList: $error',
        ),
      );
    }
  }

  // Đồng bộ toàn bộ WishList trên máy lên Firebase.
  Future<void> syncToFirebase() async {
    final current = state.asData?.value;

    if (state.isLoading || current == null || current.isBusy) {
      return;
    }

    final repository = ref.read(photoRepositoryProvider);

    state = AsyncData(
      WishlistState(
        photos: current.photos,
        isBusy: true,
      ),
    );

    try {
      await repository.syncWishlistToFirebase();

      state = AsyncData(
        WishlistState(
          photos: current.photos,
          message: 'Đã đồng bộ WishList lên Firebase.',
        ),
      );
    } catch (error) {
      state = AsyncData(
        WishlistState(
          photos: current.photos,
          message: 'Chưa đồng bộ xong Firebase: $error',
        ),
      );
    }
  }

  // Đọc lại SQLite, dùng khi thử lại sau lỗi tải ban đầu.
  Future<void> reload() async {
    final current = state.asData?.value;

    if (state.isLoading || (current?.isBusy ?? false)) {
      return;
    }

    final repository = ref.read(photoRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final photos = await repository.getWishlist();

      return WishlistState(photos: photos);
    });
  }
}