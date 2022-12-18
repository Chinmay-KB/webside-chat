import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'dart:js' as js;

class WebsideApp extends StatefulWidget {
  const WebsideApp({super.key, required this.client});
  final StreamChatClient client;

  @override
  State<WebsideApp> createState() => _WebsideAppState();
}

class _WebsideAppState extends State<WebsideApp> {
  Channel? channel;

  @override
  void initState() {
    super.initState();
    getUrl();
  }

  void getUrl() {
    var queryInfo = js.JsObject.jsify({'active': true, 'currentWindow': true});
    js.context['chrome']['tabs']?.callMethod('query', [
      queryInfo,
      (tabs) async {
        var url = tabs[0]['url'];

        channel = widget.client.channel(
          'livestream',
          id: md5.convert(utf8.encode(url)).toString(),
          extraData: {
            'name': tabs[0]['title'],
          },
        );

        await channel!.watch();

        setState(() {});
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (channel == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return StreamChannel(
      channel: channel!,
      child: Scaffold(
        appBar: const StreamChannelHeader(
          showBackButton: false,
        ),
        body: Column(
          children: const [
            Expanded(child: StreamMessageListView()),
            StreamMessageInput()
          ],
        ),
      ),
    );
  }
}
