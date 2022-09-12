class Failure {
  String? message;
  FailureType? type;

  Failure({this.message, this.type});
}

enum FailureType { networkError, responseError }
