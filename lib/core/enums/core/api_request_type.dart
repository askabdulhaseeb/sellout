enum ApiRequestType {
  get('GET'),
  post('POST'),
  patch('PATCH'),
  delete('DELETE');

  const ApiRequestType(this.json);
  final String json;
}
