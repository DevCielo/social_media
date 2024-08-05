import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_tree/models/tweet.dart';
import 'package:widget_tree/pages/create.dart';
import 'package:widget_tree/providers/tweet_provider.dart';
import 'package:widget_tree/providers/user_provider.dart';
import 'settings.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
        title: const Text('Home Screen'),
        leading: _buildProfileIcon(currentUser),
      ),
      body: ref.watch(feedProvider).when(
        data: (List<Tweet> tweets) {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(color:  Colors.black,),
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(foregroundImage: NetworkImage(tweets[index].profilePic),),
                title: Text(tweets[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(tweets[index].tweet, style: TextStyle(color: Colors.black, fontSize: 16)), 
              );
            },
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('Error loading tweets'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateTweet()),
          );
        },
        child: Icon(Icons.add),
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
