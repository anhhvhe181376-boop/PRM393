// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(photoRepository)
final photoRepositoryProvider = PhotoRepositoryProvider._();

final class PhotoRepositoryProvider
    extends
        $FunctionalProvider<PhotoRepository, PhotoRepository, PhotoRepository>
    with $Provider<PhotoRepository> {
  PhotoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoRepositoryHash();

  @$internal
  @override
  $ProviderElement<PhotoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoRepository create(Ref ref) {
    return photoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoRepository>(value),
    );
  }
}

String _$photoRepositoryHash() => r'322255602e66654cc00a90b7a2948337e8b22a54';

@ProviderFor(PhotoViewModel)
final photoViewModelProvider = PhotoViewModelProvider._();

final class PhotoViewModelProvider
    extends $AsyncNotifierProvider<PhotoViewModel, List<Photo>> {
  PhotoViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoViewModelHash();

  @$internal
  @override
  PhotoViewModel create() => PhotoViewModel();
}

String _$photoViewModelHash() => r'5995b070b34ef6e6c9f7ae08e8952f13d4f333db';

abstract class _$PhotoViewModel extends $AsyncNotifier<List<Photo>> {
  FutureOr<List<Photo>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Photo>>, List<Photo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Photo>>, List<Photo>>,
              AsyncValue<List<Photo>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
