class Dog < ApplicationRecord
    after_create :publish_dog

    private
    def publish_dog()
        queue_name = "dogs"
        publisher = PublisherService.new
        queue = publisher.declare_queue(queue_name)
        payload = self.to_json
        publisher.publish_message(queue.name, payload)
        publisher.close_connection
    end
end
