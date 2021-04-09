require "kafka"

$kafka = Kafka.new(%w[kafka1:9092 kafka2:9092], logger: Rails.logger)

$kafka_producer = $kafka.async_producer(
  delivery_interval: 10,
)

at_exit { $kafka_producer.shutdown }