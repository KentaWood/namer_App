import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/main.dart';

void main() {
  // Test Case 1: Test that the MyAppState starts with a random word pair
  test('MyAppState starts with a random word pair', () {
    final appState = MyAppState();
    
    // Print the favorites list to check it
    print(appState.favorites.toString());

    // Assert that the initial word pair is not null
    expect(appState.current, isNotNull);
  });

  // Test Case 2: Test that the favorites list starts empty
  test('MyAppState favorites list starts empty', () {
    final appState = MyAppState();

    // Assert that the favorites list is initially empty
    expect(appState.favorites, isEmpty);
  });

  // Test Case 3: Test toggling a word pair to the favorites list
  test('Toggling a word pair adds it to favorites', () {
    final appState = MyAppState();
    
    // Store the initial length of the favorites list
    final initialFavoritesCount = appState.favorites.length;

    // Toggle the current word pair to the favorites
    appState.toggleFavorite();

    // Assert that the favorites list length has increased by 1
    expect(appState.favorites.length, initialFavoritesCount + 1);
    expect(appState.favorites.contains(appState.current), isTrue);
  });
}

