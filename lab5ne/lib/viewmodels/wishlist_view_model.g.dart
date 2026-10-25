// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WishlistViewModel)
final wishlistViewModelProvider = WishlistViewModelProvider._();

final class WishlistViewModelProvider
    extends $AsyncNotifierProvider<WishlistViewModel, WishlistState> {
  WishlistViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistViewModelHash();

  @$internal
  @override
  WishlistViewModel create() => WishlistViewModel();
}

String _$wishlistViewModelHash() => r'032144d7bf3136006d28b26e48d26b1bf31841c4';

abstract class _$WishlistViewModel extends $AsyncNotifier<WishlistState> {
  FutureOr<WishlistState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WishlistState>, WishlistState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WishlistState>, WishlistState>,
              AsyncValue<WishlistState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
