import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
  child: Center(
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.push('/create-party');
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Party'),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.push('/join-party');
              },
              icon: const Icon(Icons.login),
              label: const Text('Join Party'),
            ),
          ),
        ],
      ),
    ),
  ),
)
    );
  }
}