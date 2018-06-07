# Get Kafka messages with KafkaEx and GenStage

## based on this lecture: https://www.youtube.com/watch?v=6ijgMvXJyuo

[Kafka](http://kafka.apache.org) is a distributed streaming platform.

I use [KafkaEx](https://github.com/kafkaex/kafka_ex) to recieve messages from it.

Then I pass it to a GenStage producer that delivers it to GenStage Consumer.

This way it allows me to get the benefit of GenStage for back-pressure.



