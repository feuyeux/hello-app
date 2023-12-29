import 'dart:math';

import 'common/common.dart';
import 'common/landing.pbgrpc.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'conn/conn.dart';
import 'package:grpc/grpc.dart';

void main() {
  runApp(HelloApp());
}

class HelloApp extends StatelessWidget {
  const HelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HelloAppState(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(0, 255, 0, 1.0)),
          useMaterial3: true,
        ),
        home: HelloHomePage(),
      ),
    );
  }
}

class HelloAppState extends ChangeNotifier {
  // words
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // favorites
  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  // grpc
  var list = <String>[];
  Future<void> askRPC() async {
    list.clear();
    list.add("====BEGIN====");
    final channel = ClientChannel('127.0.0.1',
        port: Conn.port,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()));
    stub = LandingServiceClient(channel,
        options: CallOptions(timeout: Duration(seconds: 30)));
    // Run all of the demos in order.
    try {
      TalkRequest request = TalkRequest()
        ..data = Utils.randomId(5)
        ..meta = "DART";
      await talk(request);
      request = TalkRequest()
        ..data =
            "${Utils.randomId(5)},${Utils.randomId(5)},${Utils.randomId(5)}"
        ..meta = "DART";
      await talkOneAnswerMore(request);
      await talkMoreAnswerOne();
      await talkBidirectional();
    } catch (e) {
      print('Caught error: $e');
    }
    await channel.shutdown();
    list.add("====END====");
    notifyListeners();
  }

  Future<TalkResponse> talk(TalkRequest request) async {
    final response = await stub.talk(request);
    list.add("Request/Response");
    list.add(response.toString());
    return response;
  }

  Future<void> talkOneAnswerMore(TalkRequest request) async {
    await for (var response in stub.talkOneAnswerMore(request)) {
      list.add("Server Streaming");
      list.add(response.toString());
    }
  }

  Future<void> talkMoreAnswerOne() async {
    Stream<TalkRequest> generateRequest(int count) async* {
      final random = Random();
      for (var i = 0; i < count; i++) {
        TalkRequest request = TalkRequest()
          ..data = Utils.randomId(5)
          ..meta = "DART";
        yield request;
        await Future.delayed(Duration(milliseconds: 100 + random.nextInt(100)));
      }
    }

    final response = await stub.talkMoreAnswerOne(generateRequest(3));
    list.add("Client Streaming");
    list.add(response.toString());
  }

  Future<void> talkBidirectional() async {
    Stream<TalkRequest> generateRequests() async* {
      for (var i = 0; i < 3; i++) {
        TalkRequest request = TalkRequest()
          ..data = Utils.randomId(5)
          ..meta = "DART";
        // Short delay to simulate some other interaction.
        await Future.delayed(Duration(milliseconds: 10));
        yield request;
      }
    }

    final call = stub.talkBidirectional(generateRequests());
    await for (var response in call) {
      list.add("Bidirectional Streaming");
      list.add(response.toString());
    }
  }
}

class HelloHomePage extends StatefulWidget {
  @override
  State<HelloHomePage> createState() => _HelloHomePageState();
}

class _HelloHomePageState extends State<HelloHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        // page = Placeholder();
        page = AsksPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  // https://fonts.google.com/icons
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.water),
                    label: Text('Asks'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
    //
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HelloAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HelloAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

late LandingServiceClient stub;

class AsksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HelloAppState>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.askRPC();
                },
                child: Text('ASK gRPC Server From Flutter'),
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.all(20)),
          for (var response in appState.list)
            ListTile(
              title: Text(response.toString()),
            ),
        ],
      ),
    );
  }
}
