// settings_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_tree/providers/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedImage = await picker.pickImage(
                source: ImageSource.gallery, requestFullMetadata: false);
              
              if (pickedImage != null) {
                ref.read(userProvider.notifier).updatePicture(File(pickedImage.path));
              }
            },
            child: CircleAvatar(
            radius: 100,
            foregroundImage: NetworkImage(currentUser.user.profilePic),
          ),
          ),
          SizedBox(height: 10,),
          Center(child: Text('Tap Image to Change'),),
        TextFormField(
          decoration: InputDecoration(labelText: 'Enter Your Name'),
          controller: _nameController,
        ),
        TextButton(onPressed: () {
          ref.read(userProvider.notifier).updateName(_nameController.text);
        }, child: Text("Update"))
      ],)
      )
    );
  }
}



  