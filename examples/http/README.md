# OpenTelemetry Ruby Example

## HTTP

This is a simple example that demonstrates tracing an HTTP request from client to server. The example shows several aspects of tracing, such as:

* Using the `TracerFactory`
* Span Events
* Span Attributes
* Creating a simple `ConsoleExporter`

### Running the example

The example uses Docker Compose to make it a bit easier to get things up and running.

1. Follow the `Developer Setup` instructions in [the main README](../../README.md)


1. Bring the server up using the `ex-http-server` compose service
    * `dcu ex-http-server`
1. Use a second shell session to get an interactive prompt in the client container using the `ex-http-client` compose service
    * `dcr --service-ports ex-http-client`
    * The `service-ports` are required to allow the client and server to communicate
1. Run the client
    * `bundle exec ruby client.rb`
1. You should see console exporter output for both the client and server sessions
