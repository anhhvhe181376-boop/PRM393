import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/photo.dart';
import '../repository/photo_repository.dart';

part 'photo_view_model.g.dart';

@Riverpod(keepAlive: true)
PhotoRepository photoRepository(Ref ref) {
  return PhotoRepository();
}

@Riverpod(keepAlive: true)
class PhotoViewModel extends _$PhotoViewModel {
  @override
  Future<List<Photo>> build() {
    final repository = ref.watch(photoRepositoryProvider);

    return repository.fetchPhotos();
  }

  Future<void> reload() async {
    if (state.isLoading) {
      return;
    }

    final repository = ref.read(photoRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => repository.fetchPhotos(),
    );
  }
}