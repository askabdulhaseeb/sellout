enum ReportType {
  spam(
    'spam',
    'Spam',
    'This post is a spam.',
  ),
  saleOfIllegal(
    'sale_of_illegal',
    'Sale of Illegal',
    'This post sells illegal items.',
  ),
  scam(
    'scam',
    'Scam',
    'This post is a scam.',
  ),
  hateSpeech(
    'hate_speech',
    'Hate Speech',
    'This post contains hate speech.',
  ),
  violenceOrDangerous(
    'violence_or_dangerous',
    'Violence or Dangerous',
    'This post promotes violence or is dangerous.',
  ),
  bullyingOrHarassment(
    'bullying_or_harassment',
    'Bullying or Harassment',
    'This post contains bullying or harassment.',
  ),
  intellectualPropertyViolation(
    'intellectual_property_violation',
    'Intellectual Property Violation',
    'This post violates intellectual property.',
  ),
  selfInjuryOrSuicide(
    'self_injury_or_suicide',
    'Self Injury or Suicide',
    'This post promotes self injury or suicide.',
  ),
  falseInformation(
    'false_information',
    'False Information',
    'This post contains false information.',
  );

  const ReportType(this.code, this.title, this.reason);

  final String code;
  final String title;
  final String reason;

  static ReportType fromCode(String? code) {
    if (code == null) return ReportType.spam;
    return ReportType.values.firstWhere(
      (ReportType e) => e.code == code,
      orElse: () => ReportType.spam,
    );
  }

  static List<ReportType> get list => ReportType.values;
}
