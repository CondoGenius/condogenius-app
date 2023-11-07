class PollOption {
  final int id;
  final String title;
  final int percentageOfVotes;
  final int quantityOfVotes;
  final List<int> votes;

  PollOption({
    required this.id,
    required this.title,
    required this.percentageOfVotes,
    required this.quantityOfVotes,
    required this.votes,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'],
      title: json['title'],
      percentageOfVotes: json['percentage_of_votes'],
      quantityOfVotes: json['quantity_of_votes'],
      votes: (json['votes'] as List<dynamic>).cast<int>(),
    );
  }
}
