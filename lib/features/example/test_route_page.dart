import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteTestPage extends StatelessWidget {
  const RouteTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoRouter Push Test'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('Standard Routes'),
            _buildPushCard(context, 'Splash', '/splash', Icons.auto_awesome),
            _buildPushCard(context, 'Login', '/login', Icons.login),
            _buildPushCard(context, 'Main Home', '/main', Icons.home),
            _buildPushCard(context, 'Image Picker', '/image_picker', Icons.image),

            const SizedBox(height: 24),
            _sectionTitle('Nested & Sub Routes'),
            _buildPushCard(context, 'Report Main', '/report', Icons.assessment),
            _buildPushCard(
                context,
                'Card Edit (Sub)',
                '/report/cardEdit',
                Icons.edit_note,
                isSub: true
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildPushCard(
      BuildContext context,
      String name,
      String path,
      IconData icon,
      {bool isSub = false}
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: isSub ? Colors.orange : Colors.blue),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(path, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // push를 사용하여 스택 위에 페이지를 쌓습니다.
          context.push(path);
        },
      ),
    );
  }
}