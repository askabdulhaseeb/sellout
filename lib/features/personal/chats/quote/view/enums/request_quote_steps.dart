enum RequestQuoteStep {
  services('select_services'),
  booking('schedule'),
  note('notes'),
  review('review');

  const RequestQuoteStep(this.label);

  final String label;
}
