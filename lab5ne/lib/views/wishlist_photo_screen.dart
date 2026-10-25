import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lab5_photo/widgets/photo_title.dart';

import '../viewmodels/wishlist_view_model.dart';
import '../widgets/theme_menu.dart';


class WishListPhotoScreen extends ConsumerWidget {
  const WishListPhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistViewModelProvider);
    final wishlist = wishlistAsync.asData?.value;

    final canSync = !wishlistAsync.isLoading &&
        !wishlistAsync.hasError &&
        wishlist != null &&
        !wishlist.isBusy;

    // Hiển thị kết quả bỏ quan tâm hoặc đồng bộ.
    ref.listen<AsyncValue<WishlistState>>(
      wishlistViewModelProvider,
      (previous, next) {
        final message = next.asData?.value.message;
        final previousMessage = previous?.asData?.value.message;

        if (message == null || message == previousMessage) {
          return;
        }

        if (ModalRoute.of(context)?.isCurrent != true) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(message)),
          );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('WishList Photo'),
        actions: [
          IconButton(
            tooltip: 'Đồng bộ danh sách trên máy lên Firebase',
            icon: const Icon(Icons.cloud_upload_outlined),
            onPressed: canSync
                ? () async {
                    await ref
                        .read(wishlistViewModelProvider.notifier)
                        .syncToFirebase();
                  }
                : null,
          ),
          const ThemeMenu(),
        ],
      ),
      body: Column(
        children: [
          if (wishlist?.isBusy ?? false)
            const LinearProgressIndicator(),

          Expanded(
            child: wishlistAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Không đọc được danh sách quan tâm.\n$error',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          await ref
                              .read(wishlistViewModelProvider.notifier)
                              .reload();
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (wishlistState) {
                final photos = wishlistState.photos;

                return RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(wishlistViewModelProvider.notifier)
                        .reload();
                  },
                  child: photos.isEmpty
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 64,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Bạn chưa quan tâm Photo nào.',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Quay lại danh sách Photo và nhấn '
                                    'trái tim để thêm.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];

                            return PhotoTile(
                              key: ValueKey(photo.id),
                              photo: photo,
                              isFavorite: true,
                              enabled: !wishlistState.isBusy,
                              onToggle: () async {
                                await ref
                                    .read(
                                      wishlistViewModelProvider.notifier,
                                    )
                                    .toggle(photo);
                              },
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}