class Qa {
  Qa({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int? id;
  final String? question;
  final String? answer;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory Qa.fromJson(Map<String, dynamic> json){
    return Qa(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
  };

  @override
  String toString(){
    return "$id, $question, $answer, $createdAt, $updatedAt, $deletedAt, ";
  }
}
