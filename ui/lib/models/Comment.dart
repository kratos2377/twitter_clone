


import 'package:uuid/uuid.dart';

class Comment {
  final Uuid user;
  final String content;

  Comment({this.user, this.content});
}