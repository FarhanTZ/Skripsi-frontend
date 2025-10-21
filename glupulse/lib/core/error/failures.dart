import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Kegagalan yang terjadi karena masalah di sisi server (misal: 404, 500, atau response error).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}