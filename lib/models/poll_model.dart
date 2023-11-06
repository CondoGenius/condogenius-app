
import 'package:condo_genius_beta/models/poll_options_model.dart';

class Poll {
  final int id;
  final String content;
  final List<PollOption> options;

  Poll({
    required this.id,
    required this.content,
    required this.options,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    final List<dynamic> optionsJson = json['options'];
    List<PollOption> options = optionsJson
        .map((optionJson) => PollOption.fromJson(optionJson))
        .toList();

    return Poll(
      id: json['id'],
      content: json['content'],
      options: options,
    );
  }
}




