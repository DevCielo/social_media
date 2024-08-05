import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_tree/models/user.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  const LocalUser({required this.id, required this.user});

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(const LocalUser(
          id: "error",
          user: FirebaseUser(
            email: "error",
            name: "error",
            profilePic: "https://www.gravatar.com/avatar/?d=mp",
          ),
        ));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> login(String email) async {
    try {
      QuerySnapshot response = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (response.docs.isEmpty) {
        print('No Firestore user associated with authenticated email $email');
        return;
      }
      if (response.docs.length != 1) {
        print('More than one Firestore user with email: $email');
        return;
      }
      state = LocalUser(
          id: response.docs[0].id,
          user: FirebaseUser.fromMap(
              response.docs[0].data() as Map<String, dynamic>));
    } catch (e) {
      print('Error logging in: $e');
    }
  }

  Future<void> signUp(String email) async {
    try {
      DocumentReference response = await _firestore.collection('users').add(
            FirebaseUser(
              email: email,
              name: "No Name",
              profilePic: "https://www.gravatar.com/avatar/?d=mp",
            ).toMap(),
          );
      DocumentSnapshot snapshot = await response.get();
      state = LocalUser(
          id: response.id,
          user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  Future<void> updateName(String name) async {
    try {
      await _firestore.collection('users').doc(state.id).update({
        'name': name,
      });
      await _updateTweetsWithName(name);
      state = state.copyWith(user: state.user.copyWith(name: name));
    } catch (e) {
      print('Error updating name: $e');
    }
  }

  Future<void> _updateTweetsWithName(String name) async {
    try {
      QuerySnapshot tweetSnapshots = await _firestore
          .collection('tweets')
          .where('uid', isEqualTo: state.id)
          .get();

      for (var doc in tweetSnapshots.docs) {
        await _firestore.collection('tweets').doc(doc.id).update({
          'name': name,
        });
      }
    } catch (e) {
      print('Error updating tweets: $e');
    }
  }

  Future<void> updatePicture(File picture) async {
    try {
      // Read the image file
      List<int> imageBytes = await picture.readAsBytes();

      // Convert List<int> to Uint8List
      Uint8List uint8listImageBytes = Uint8List.fromList(imageBytes);

      // Decode the image
      img.Image image = img.decodeImage(uint8listImageBytes)!;

      // Resize the image to a maximum width of 800 pixels (you can adjust this value)
      img.Image resizedImage = img.copyResize(image, width: 800);

      // Encode the resized image back to a list of bytes
      List<int> compressedImageBytes = img.encodeJpg(resizedImage, quality: 85);

      // Create a temporary file to store the compressed image
      File compressedImageFile = File('${picture.path}_compressed.jpg');
      await compressedImageFile.writeAsBytes(compressedImageBytes);

      // Upload the compressed image to Firebase Storage
      Reference ref = _storage.ref().child('users').child(state.id);
      TaskSnapshot snapshot = await ref.putFile(compressedImageFile);
      String profilePicUrl = await snapshot.ref.getDownloadURL();

      // Update the Firestore user document with the new profile picture URL
      await _firestore.collection('users').doc(state.id).update({
        'profilePic': profilePicUrl,
      });
      await _updateTweetsWithProfilePic(profilePicUrl);
      state = state.copyWith(user: state.user.copyWith(profilePic: profilePicUrl));

      // Clean up the temporary compressed image file
      await compressedImageFile.delete();
    } catch (e) {
      print('Error updating picture: $e');
    }
  }

  Future<void> _updateTweetsWithProfilePic(String profilePicUrl) async {
    try {
      QuerySnapshot tweetSnapshots = await _firestore
          .collection('tweets')
          .where('uid', isEqualTo: state.id)
          .get();

      for (var doc in tweetSnapshots.docs) {
        await _firestore.collection('tweets').doc(doc.id).update({
          'profilePic': profilePicUrl,
        });
      }
    } catch (e) {
      print('Error updating tweets: $e');
    }
  }

  void logout() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(
        email: "error",
        name: "error",
        profilePic: "https://www.gravatar.com/avatar/?d=mp",
      ),
    );
  }
}
