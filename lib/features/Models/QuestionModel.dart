class QuestionModel {
  final String id;
  final String title;
  final bool multiSelect;
  final List<QuestionOption> options;

  QuestionModel({
    required this.id,
    required this.title,
    required this.multiSelect,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      title: json['title'],
      multiSelect: json['multi_select'],
      options: (json['options'] as List)
          .map((e) => QuestionOption.fromJson(e))
          .toList(),
    );
  }
}

class QuestionOption {
  final String id;
  final String label;

  QuestionOption({
    required this.id,
    required this.label,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'],
      label: json['label'],
    );
  }
}
