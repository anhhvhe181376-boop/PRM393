
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service/firebase_service.dart' as app_firebase;
import 'viewmodels/theme_view_model.dart';
import 'views/photo_screen.dart';
import 'views/wishlist_photo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
   await app_firebase.FirebaseService.initialize();
  } catch (error) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Không khởi tạo được Firebase.\n'
                'Kiểm tra cấu hình rồi chạy lại ứng dụng.\n\n'
                '$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    return;
  }

  runApp(const ProviderScope(child: PhotoApp()));
}

class PhotoApp extends ConsumerWidget {
  const PhotoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeViewModelProvider);

    return MaterialApp(
      title: 'Lab 5 - Photo',
      debugShowCheckedModeBanner: false,

      // Giao diện sáng.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),

      // Giao diện tối.
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),

      // Lựa chọn hiện tại từ ThemeViewModel.
      themeMode: themeAsync.asData?.value ?? ThemeMode.system,

      // Đọc cấu hình xong mới hiển thị màn hình Photo.
      home: themeAsync.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stackTrace) => Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Không đọc được cấu hình giao diện.\n$error',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      await ref.read(themeViewModelProvider.notifier).reload();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (_) => const PhotoScreen(),
      ),

      routes: {'/wishlist': (context) => const WishListPhotoScreen()},
    );
  }
}
