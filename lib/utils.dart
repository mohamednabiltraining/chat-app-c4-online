import 'package:flutter/material.dart';

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

void showMessage(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('ok'))
          ],
        );
      });
}

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 12,
              ),
              Text('Loading...')
            ],
          ),
        );
      },
      barrierDismissible: false);
}

void hideLoading(BuildContext context) {
  Navigator.pop(context);
}

class Category {
  static const String musicId = 'music';
  static const String sportsId = 'sports';
  static const String moviesId = 'movies';

  late String id;
  late String name;
  late String image;

  Category(this.id, this.name, this.image);

  Category.fromId(String id) {
    if (id == musicId) {
      this.id = musicId;
      name = "Music";
      image = 'assets/images/music.png';
    } else if (id == sportsId) {
      this.id = sportsId;
      name = "Sports";
      image = 'assets/images/sports.png';
    } else if (id == moviesId) {
      this.id = moviesId;
      name = "Movies";
      image = 'assets/images/movies.png';
    }
  }
}

List<Category> categories = [
  Category.fromId(Category.sportsId),
  Category.fromId(Category.moviesId),
  Category.fromId(Category.musicId),
];
