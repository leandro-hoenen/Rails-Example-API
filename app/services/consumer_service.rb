class ConsumerService 
  
    attr_accessor :new_connection, :channel
    def initialize
      @new_connection = BaseService.new
      @new_connection.start
      @channel = @new_connection.create_channel
       
      @channel.prefetch(1)
      puts "Consumeer Channel Created"
    end
  
    def declare_queue(queue_name = "default", durable = false)
      puts "A queue with name #{queue_name} declared"
      @channel.queue(queue_name, durable: durable)
    end
  
    def consume_message(queue)
      puts "Start Consuming Message"
      begin
        msg = nil
        queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, payload|
          puts " [x] Received '#{payload}'"
          channel.ack(delivery_info.delivery_tag)
          msg = payload
        end
        return msg
      rescue Interrupt => _
        close_connection
      end
      return false
    end
  
    def close_connection
      puts "Connections Closed"
      @new_connection.close  
    end
  end