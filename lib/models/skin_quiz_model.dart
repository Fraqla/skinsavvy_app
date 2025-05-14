class Answer {
  final String text;
  final int score;

  Answer({required this.text, required this.score});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'],
      score: int.tryParse(json['score'].toString()) ?? 0,  // Ensures score is an integer
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'score': score,
    };
  }
}


class SkinQuizModel {
  final int id;
  final String question;
  final List<Answer> answers;

  SkinQuizModel({
    required this.id,
    required this.question,
    required this.answers,
  });

  factory SkinQuizModel.fromJson(Map<String, dynamic> json) {
    var list = json['answers'] as List;
    List<Answer> answersList = list.map((i) => Answer.fromJson(i)).toList();

    return SkinQuizModel(
      id: int.tryParse(json['id'].toString()) ?? 0,  // Ensures that id is an integer
      question: json['question'],
      answers: answersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}
