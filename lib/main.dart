import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Entry point of the application and File 
void main() {
  runApp(MyApp());
}

// MyApp class that sets up the application and provides state management
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provides app state to the widget tree
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',  // App's title
        theme: ThemeData(
          useMaterial3: true,  
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(211, 102, 39, 1)), // Custom theme color
        ),
        home: MyHomePage(),  // Home page of the app
      ),
    );
  }
}

// State class for managing the current word and list of favorites
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();  // Holds the current random word pair

  // Method to generate a new random word pair
  void getNext() {
    current = WordPair.random();
    notifyListeners();  
  }

  var favorites = <WordPair>[];  // List of favorite word pairs

  // Method to toggle a word pair between favorites and non-favorites
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);  
    } else {
      favorites.add(current);  
    }
    notifyListeners();  
  }
}

// Main page of the app with navigation and content display
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;  // Track the selected page in the navigation rail

  @override
  Widget build(BuildContext context) {
    // Set the page based on the selected index
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();  // Page for generating new word pairs
        break;
      case 1:
        page = FavoritesPage();  // Page for displaying favorite word pairs
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return Scaffold(
      // Layout with a navigation rail and a page display area
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),  
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.fireplace),
                  label: Text('Favorites'), 
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;  // Update selected index on navigation rail
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,  // Display the selected page
            ),
          ),
        ],
      ),
    );
  }
}

// Page for generating new random word pairs
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();  // Watch app state for updates
    var pair = appState.current;  // Current random word pair

    IconData icon;
    String toolTipMessageFavorite;

    // Determine whether the current word pair is in favorites
    if (appState.favorites.contains(pair)) {
      icon = Icons.fireplace;
      toolTipMessageFavorite = "You favorited this word!";
    } else {
      icon = Icons.fireplace_outlined;
      toolTipMessageFavorite = "Click to favorite!";
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
              Tooltip(
                message: toolTipMessageFavorite,
                child: ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();  // Toggle favorite status for the word pair
                  },
                  icon: Icon(icon),
                  label: Text('Like'),  // Button label for liking a word pair
                ),
              ),
              SizedBox(width: 10),
              Tooltip(
                message: "Click to get another random word!",
                child: ElevatedButton(
                  onPressed: () {
                    appState.getNext();  
                  },
                  child: Text('Next'),  // Button label for generating the next word
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Page for displaying the list of favorite word pairs
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();  // Watch app state for updates

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),  // Display when there are no favorites
      );
    }

    // Display the list of favorites
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),
        
        // Display each favorite word pair
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.fireplace),
            title: Text(pair.asLowerCase), 
          ),
      ],
    );
  }
}

// Widget for displaying a word pair in a large card
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);  // Access the app's theme
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,  // Apply text style with theme colors
    );

    // Display the word pair in a card
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pair.asCamelCase, 
          style: style,
          semanticsLabel: pair.asPascalCase,  
        ),
      ),
    );
  }
}
