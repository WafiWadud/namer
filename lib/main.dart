import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<String> names = [];
  String currentName = '';
  String toBeCurrentName = '';
  List<String> likedNames = [];
  List<String> seenNames = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    loadNamesFromFile();
  }

  void loadNamesFromFile() async {
    try {
      final String content = await rootBundle.loadString('assets/names.txt');
      final List<String> lines = content.split('\n');
      setState(() {
        names = lines;
        currentName = names[random.nextInt(names.length)];
      });
    } catch (e) {
      currentName = e.toString();
    }
  }

  void likeName() {
    setState(() {
      likedNames.add(currentName);
      nextName();
    });
  }

  void nextName() {
    setState(() {
      names.remove(currentName);
      if (names.isEmpty) {
        currentName = 'All names have been seen';
      } else {
        currentName = names[random.nextInt(names.length)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namer'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoritesScreen(likedNames)),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Name:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              currentName,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ElevatedButton(
              onPressed: likeName,
              child: const Text('Like this name'),
            ),
            ElevatedButton(
              onPressed: () => nextName(),
              child: const Text('Next name'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<String> likedNames;

  const FavoritesScreen(this.likedNames, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: likedNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(likedNames[index]),
          );
        },
      ),
    );
  }
}
