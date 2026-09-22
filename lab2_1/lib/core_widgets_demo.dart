import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 - Core Widgets'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Icon(
                Icons.movie,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            Image.network(
              'https://picsum.photos/600/300',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Movie Item'),
                subtitle: const Text(
                  'This is a sample ListTile inside a Card.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}