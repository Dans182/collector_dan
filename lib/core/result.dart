sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  }) {
    final current = this;
    if (current is Success<T>) {
      return success(current.value);
    }
    if (current is Failure<T>) {
      return failure(current.message);
    }
    throw StateError('Unsupported Result state: $runtimeType');
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message);

  final String message;
}
