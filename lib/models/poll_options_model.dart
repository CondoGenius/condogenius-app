class PollOption {
  final int id;
  final String title;
  final double percentageOfVotes;

  PollOption({
    required this.id,
    required this.title,
    required this.percentageOfVotes,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'],
      title: json['title'],
      percentageOfVotes: json['percentage_of_votes'].toDouble(),
    );
  }
}
