import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RatingPopup(),
    );
  }
}

class RatingPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rating Popup Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showRatingDialog(context);
          },
          child: Text('Rate Provider'),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Give your Rating'),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                itemSize: 40,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                onRatingUpdate: (rating) {
                  print('Rating: $rating');
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Comments',
                  hintText: 'Nice work',
                ),
              ),
              SizedBox(height: 10),
              Text('Provider name: Jorge Bond'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle submit
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
