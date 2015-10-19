//
//  Channel.swift
//  HastyHare
//
//  Created by Sven A. Schmidt on 30/09/2015.
//  Copyright © 2015 feinstruktur. All rights reserved.
//

import Foundation
import RabbitMQ


public class Channel {

    private let _connection: amqp_connection_state_t
    private let _channel: amqp_channel_t
    internal var _open = false


    init(connection: amqp_connection_state_t, channel: amqp_channel_t) {
        self._connection = connection
        self._channel = channel
        amqp_channel_open(connection, channel)
        self._open = success(connection, printError: true)
    }


    deinit {
        amqp_channel_close(self.connection, self.channel, AMQP_REPLY_SUCCESS)
    }


    public var open: Bool {
        return _open
    }

    public var connection: amqp_connection_state_t {
        return self._connection
    }

    public var channel: amqp_channel_t {
        return self._channel
    }


    public func declareQueue(name: String, passive: Bool = false, durable: Bool = false, exclusive: Bool = false, autoDelete: Bool = false) -> Queue {
        return Queue(channel: self, name: name, passive: passive, durable: durable, exclusive: exclusive, autoDelete: autoDelete)
    }


    public func declareExchange(name: String, type: ExchangeType = .Direct, passive: Bool = false, durable: Bool = false, autoDelete: Bool = false) -> Exchange {
        return Exchange(channel: self, name: name, type: type, passive: passive, durable: durable, autoDelete: autoDelete)
    }


    public func consumer(queueName: String) -> Consumer {
        return Consumer(channel: self, queueName: queueName)
    }


    public func consumer(queue: Queue) -> Consumer {
        return Consumer(channel: self, queueName: queue.name)
    }

}

