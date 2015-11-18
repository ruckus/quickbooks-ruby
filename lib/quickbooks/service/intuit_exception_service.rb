module Quickbooks
  class SSLError < IntuitRequestException; end
  class ServerError < IntuitRequestException; end
  class ConcurrencyError < IntuitRequestException; end
  class HTTPError < IntuitRequestException; end
  class TimeoutError < IntuitRequestException; end

  module Service
    class IntuitExceptionService

      SSL_ERRORS = [
        "SSL_connect returned=1",
        "SSL_connect SYSCALL returned=5",
        "SSL_read: unexpected record",
        "SSL_read: ssl handshake failure",
        "SSL_write: protocol is shutdown",
        "SSL_write: uninitialized",
      ]

      SERVER_ERRORS = [
        "message=InternalServerError",
        "statusCode=500",
        "statusCode: 500",
        "System Failure Error",
      ]

      CONCURRENCY_ERRORS = [
        "You can only add or edit one product or service at a time",
        "You can only add or edit one name at a time",
        "Stale Object Error"
      ]

      HTTP_ERRORS = [
        "Unhandled HTTP Redirect",
        "HTTP Error Code: 404",
        "No route to host - connect(2)",
      ]

      TIMEOUT_ERRORS = [
        "end of file reached",
        "attempt to read body out of block",
      ]

      def self.parse(exception)
        new(exception).parse
      end

      def initialize(exception)
        @exception = exception
        @message = exception[:message] + exception[:details]
      end

      def parse
        if test? SSL_ERRORS
          Quickbooks::SSLError
        elsif test? SERVER_ERRORS
          Quickbooks::ServerError
        elsif test? CONCURRENCY_ERRORS
          Quickbooks::ConcurrencyError
        elsif test? HTTP_ERRORS
          Quickbooks::HTTPError
        elsif test? TIMEOUT_ERRORS
          Quickbooks::TimeoutError
        else
          Quickbooks::IntuitRequestError
        end
      end

      def test?(triggers)
        triggers.any? { |trigger| @message.include?(trigger) }
      end
    end
  end
end
