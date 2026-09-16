import 'package:flutter/material.dart';
import '../Widgets/MyAppBar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/images.jpg',
              width: 350,
              height: 350,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20), // Tạo khoảng cách giữa ảnh và chữ
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), // Kích thước chữ chung
                children: [
                  TextSpan(
                    text: 'Hello ',
                    style: TextStyle(color: Colors.blue), // Màu thứ nhất
                  ),
                  TextSpan(
                    text: 'Flutter',
                    style: TextStyle(color: Colors.red), // Màu thứ hai
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}