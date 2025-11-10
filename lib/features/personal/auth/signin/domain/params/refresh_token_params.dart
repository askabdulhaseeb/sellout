class RefreshTokenParams {
  const RefreshTokenParams({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'refresh_token': refreshToken,
      };
}
