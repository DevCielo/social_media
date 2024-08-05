import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widget_tree/providers/tweet_provider.dart';

class CreateTweet extends ConsumerWidget {
  const CreateTweet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _tweetController = TextEditingController();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Post a Tweet')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(padding: const EdgeInsets.all(10.0),
        child: TextField(
          maxLines: 4,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          controller: _tweetController,
          maxLength: 280,
          )
      ),
      TextButton(
        onPressed: () async {
          await ref.read(tweetProvider).postTweet(_tweetController.text);
          Navigator.pop(context);

        },
        child: Text('Post Tweet'),)
      
      ],)
    );
  }
}