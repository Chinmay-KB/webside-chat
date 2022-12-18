import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:unique_name_generator/unique_name_generator.dart';
import 'dart:html';

import 'package:webside_chat/chat_screen.dart';

const apiKey = ""; // Replace with your API key

String getUsername() {
  late String username;
  if (window.localStorage.containsKey('username')) {
    username = window.localStorage['username']!;
  } else {
    username = UniqueNameGenerator(
        separator: '-',
        style: NameStyle.lowerCase,
        dictionaries: [
          adjectives,
          animals,
          colors,
        ]).generate();
    window.localStorage['username'] = username;
  }
  return username;
}

void main() async {
  final client = StreamChatClient(
    apiKey,
    logLevel: Level.INFO,
  );
  final username = getUsername();
  await client.connectUser(
    User(id: username),
    client.devToken(username).rawValue,
  );
  runApp(MaterialApp(
    builder: (context, child) {
      return StreamChat(client: client, child: child);
    },
    home: WebsideApp(
      client: client,
    ),
  ));
}
