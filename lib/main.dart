import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Post Fetcher',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map<String, dynamic>? post;
  bool isLoading = false;

  Future<void> fetchRandomPost() async {
    setState(() {
      isLoading = true;
    });

    try {
      final int randomId = Random().nextInt(100) + 1;
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$randomId'));

      if (response.statusCode == 200) {
        setState(() {
          post = jsonDecode(response.body);
        });
      } else {
        setState(() {
          post = {"error": "Failed to fetch post"};
        });
      }
    } catch (e) {
      setState(() {
        post = {"error": "An error occurred: $e"};
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Post Fetcher'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : post == null
            ? Text('Press the button to fetch a random post!')
            : post!["error"] != null
            ? Text(post!["error"])
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title:',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                post!["title"] ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Body:',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                post!["body"] ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRandomPost,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
