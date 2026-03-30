class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  // This "factory" is the bridge between the API and your App
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      // API Ninjas uses the key 'quote', but we want to use 'text' in our app
      text: json['quote'] ?? 'Stay vigilant and safe.', 
      author: json['author'] ?? 'CampusGuard',
    );
  }
}