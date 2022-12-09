import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final apiKey = "my8m32m792hh";
final userToken =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2VhdGhlcmVkLXN1bnNldC0wIn0.fXqI_yTYHtf6Cu1w-wLNi3rBYoWp40c7Ds1YFm52_NE";

/// Create a new instance of [StreamChatClient] passing the apikey obtained from
/// your project dashboard.
final client = StreamChatClient(
  'my8m32m792hh',
  logLevel: Level.INFO,
);
final channel = client.channel(
  'messaging',
  id: 'flutterdevs',
  extraData: {
    'name': 'Flutter devs',
  },
);

void main() async {
  /// Set the current user and connect the websocket.
  /// In a production scenario, this should be done using a backend to generate
  /// a user token using our server SDK.
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'super-band-9'),
    userToken,
  );
  await channel.watch();
  runApp(MaterialApp(
    builder: (context, child) {
      return StreamChat(client: client, child: child);
    },
    home: const WebsideApp(),
  ));
}

class WebsideApp extends StatelessWidget {
  const WebsideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: channel,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final message = Message(
              text:
                  'I told them I was pesca-pescatarian. Which is one who eats solely fish who eat other fish. ${DateTime.now.toString()}',
              extraData: {
                'customField': '123',
              },
            );
            // await channel.sendMessage(message);
          },
        ),
        body: Column(
          children: [
            Expanded(child: StreamMessageListView()),
            StreamMessageInput()
          ],
        ),
      ),
    );
  }
}
