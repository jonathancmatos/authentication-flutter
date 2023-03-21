import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String title;
  final String text;

  const Message({required this.title, required this.text});

  @override
  List<Object?> get props => [title, text];
}
