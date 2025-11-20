enum AuthProviderEnum {
  email('Email', 'email'),
  google('Google', 'google.com'),
  apple('Apple', 'apple.com');

  final String displayName;
  final String providerId;

  const AuthProviderEnum(this.displayName, this.providerId);
}

