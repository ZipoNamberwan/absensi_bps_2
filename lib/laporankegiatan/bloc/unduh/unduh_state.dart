class UnduhState {
  final DateTime from;
  final DateTime to;

  UnduhState({this.from, this.to});

  bool isValid() {
    return from != null && to != null;
  }
}

class InitialunduhState extends UnduhState {
  InitialunduhState() : super();
}

class LoadingState extends UnduhState {
  LoadingState({DateTime from, DateTime to}) : super(from: from, to: to);
}

class SuccessState extends UnduhState {
  SuccessState({DateTime from, DateTime to}) : super(from: from, to: to);
}

class ErrorState extends UnduhState {
  final String message;

  ErrorState(this.message, {DateTime from, DateTime to})
      : super(from: from, to: to);
}
