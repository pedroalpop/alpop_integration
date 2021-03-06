# frozen_string_literal: true

require 'middleware'
require 'query_builder'
require 'base'

# Zendesk module.
module Zendesk
  API = 'zendesk'

  # Zendesk Ticket ruby object.
  class Ticket < Base
    attr_accessor :id

    @middleware = Middleware.instance
    @query_builder = QueryBuilder.new

    def initialize(id = nil)
      @id = id
    end

    def self.find(id)
      response_body = super('find', 'GET', { id: id })
      Ticket.parse(response_body, 'find')
    end

    def self.parse(response, method)
      response = JSON.parse(response)
      method = "parse_#{method}"
      Ticket.send(method, response)
    end

    def self.parse_find(response)
      ticket_id = response['ticket']['id']
      Ticket.new(ticket_id)
    end
  end
end
