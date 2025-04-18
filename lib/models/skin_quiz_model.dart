class SkinQuizModel {
  final int id;
  final String question;
  final List<String> answers;

  SkinQuizModel({
    required this.id,
    required this.question,
    required this.answers,
  });

  factory SkinQuizModel.fromJson(Map<String, dynamic> json) {
    return SkinQuizModel(
      id: json['id'],
      question: json['question'],
      answers: List<String>.from(json['answers']),
    );
  }
}
