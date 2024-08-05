import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_tree/providers/user_provider.dart';
import 'settings.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        leading: _buildProfileIcon(currentUser),
      ),
      body: Column(
        children: [
          Text(currentUser.user.email),
          Text(currentUser.user.name),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(currentUser.user.profilePic),
            ListTile(
              title: Text(
                'Hello, ${currentUser.user.name}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon(LocalUser currentUser) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: currentUser.user.profilePic.isNotEmpty
                  ? NetworkImage(currentUser.user.profilePic)
                  : null,
              onBackgroundImageError: (_, __) {
                // Handle the error case
              },
              child: currentUser.user.profilePic.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
