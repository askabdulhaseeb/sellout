enum ReportType {
  spam(
    'spam',
    'Spam',
  ),
  saleOfIllegal(
    'sale_of_illegal',
    'Sale of Illegal',
  ),
  scam('scam', 'Scam'),
  hateSpeech(
    'hate_speech',
    'Hate Speech',
  ),
  violenceOrDangerous(
    'violence_or_dangerous_organization',
    'Violence or Dangerous',
  ),
  bullyingOrHarassment(
    'bullying_or_harassment',
    'Bullying or Harassment',
  ),
  intellectualPropertyViolation(
    'intellectual_property_violation',
    'Intellectual Property Violation',
  ),
  selfInjuryOrSuicide(
    'self_injury_or_suicide',
    'Self Injury or Suicide',
  ),
  falseInformation(
    'false_information',
    'False Information',
  );

  const ReportType(this.code, this.title);

  final String code;
  final String title;

  static ReportType fromCode(String? code) {
    if (code == null) return ReportType.spam;
    return ReportType.values.firstWhere(
      (ReportType e) => e.code == code,
      orElse: () => ReportType.spam,
    );
  }

  static List<ReportType> get list => ReportType.values;
}
