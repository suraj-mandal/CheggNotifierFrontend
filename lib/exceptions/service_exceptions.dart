import 'dart:io';

class ServerException extends HttpException {
  const ServerException(super.message);
}

class BadRequestException extends HttpException {
  const BadRequestException(super.message);
}

class ClientException extends HttpException {
  const ClientException(super.message);
}
