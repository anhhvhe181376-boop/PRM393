import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/photo.dart';

class PhotoApiService {
  static const String _photosUrl =
      'https://jsonplaceholder.typicode.com/photos';

  Future<List<Photo>> fetchPhotos() async {
    // Bước 1: Gửi yêu cầu GET đến API.
    final response = await http
        .get(Uri.parse(_photosUrl))
        .timeout(const Duration(seconds: 20));

    // Bước 2: Kiểm tra kết quả HTTP.
    if (response.statusCode != 200) {
      throw Exception(
        'Không lấy được danh sách Photo. '
        'Mã lỗi: ${response.statusCode}',
      );
    }

    // Bước 3: Giải mã chuỗi JSON thành danh sách.
    final decoded = jsonDecode(
      utf8.decode(response.bodyBytes),
    );

    if (decoded is! List) {
      throw const FormatException(
        'Dữ liệu Photo trả về không phải danh sách.',
      );
    }

    // Bước 4: Chuyển mỗi phần tử thành đối tượng Photo.
    return decoded.map((item) {
      return Photo.fromMap(
        item as Map<String, dynamic>,
      );
    }).toList();
  }
}