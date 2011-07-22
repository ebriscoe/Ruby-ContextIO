require 'oauth'
require 'net/http'

module ContextIO
  VERSION = "2.0"

  class ContextIO::Connection
    def initialize(key='', secret='', server='https://api-preview.context.io')
      @consumer = OAuth::Consumer.new(key, secret, {:site => server, :sheme => :header})
      @token    = OAuth::AccessToken.new @consumer
    end

    def discovery(options)
      get 'discovery', {:source => 'imap'}.merge(options)
    end

    def list_oauth_providers
      get 'oauth_providers'
    end

    def get_oauth_provider(options)
      if ! options.has_key?(:consumer_key) then
        raise ArgumentError, "missing required argument consumer_key", caller
      end
      get "oauth_providers/#{options[:consumer_key]}"
    end

    def delete_oauth_provider(options)
      if ! options.has_key?(:consumer_key) then
        raise ArgumentError, "missing required argument consumer_key", caller
      end
      delete "oauth_providers/#{options[:consumer_key]}"
    end

    def list_contacts(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/contacts", options
    end

    def get_contact(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      get "accounts/#{options[:account]}/contacts/#{options[:email]}"
    end

    def list_contact_files(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      account = options.delete(:account)
      email = options.delete(:email)
      get "accounts/#{account}/contacts/#{email}/files", options
    end

    def list_contact_messages(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      account = options.delete(:account)
      email = options.delete(:email)
      get "accounts/#{account}/contacts/#{email}/messages", options
    end

    def list_contact_threads(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      account = options.delete(:account)
      email = options.delete(:email)
      get "accounts/#{account}/contacts/#{email}/threads", options
    end

    def list_files(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/files", options
    end

    def get_file(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      get "accounts/#{options[:account]}/files/#{options[:file_id]}"
    end

    def get_file_content(options)
      get "accounts/#{options[:account]}/files/#{options[:file_id]}/content"
    end

    def get_file_changes(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      account = options.delete(:account)
      file_id = options.delete(:file_id)
      get "accounts/#{account}/files/#{file_id}/changes", options
    end

    def list_file_revisions(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      account = options.delete(:account)
      file_id = options.delete(:file_id)
      get "accounts/#{account}/files/#{file_id}/revisions", options
    end

    def list_file_related(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:file_id) then
        raise ArgumentError, "missing required argument file_id", caller
      end
      account = options.delete(:account)
      file_id = options.delete(:file_id)
      get "accounts/#{account}/files/#{file_id}/related", options
    end

    def list_messages(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/messages", options
    end

    def get_message(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end

      account = options.delete(:account)
      if options.has_key?(:email_message_id) then
        email_message_id = options.delete(:email_message_id)
        get "accounts/#{account}/messages/#{email_message_id}"
      elsif options.has_key?(:message_id) then
        message_id = options.delete(:message_id)
        get "accounts/#{account}/messages/#{message_id}"
      elsif options.has_key?(:gmail_message_id) then
        gmail_message_id = options.delete(:gmail_message_id)
        if options[:gmail_message_id].start_with?('gm-') then
          get "accounts/#{account}/messages/#{gmail_message_id}"
        else
          get "accounts/#{account}/messages/gm-#{gmail_message_id}"
        end
      end
    end

    def get_message_headers(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end

      account = options.delete(:account)
      if options.has_key?(:email_message_id) then
        email_message_id = options.delete(:email_message_id)
        get "accounts/#{account}/messages/#{email_message_id}/headers"
      elsif options.has_key?(:message_id) then
        message_id = options.delete(:message_id)
        get "accounts/#{account}/messages/#{message_id}/headers"
      elsif options.has_key?(:gmail_message_id) then
        gmail_message_id = options.delete(:gmail_message_id)
        if options[:gmail_message_id].start_with?('gm-') then
          get "accounts/#{account}/messages/#{gmail_message_id}/headers"
        else
          get "accounts/#{account}/messages/gm-#{gmail_message_id}/headers"
        end
      end
    end

    def get_message_flags(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end

      account = options.delete(:account)
      if options.has_key?(:email_message_id) then
        email_message_id = options.delete(:email_message_id)
        get "accounts/#{account}/messages/#{email_message_id}/flags"
      elsif options.has_key?(:message_id) then
        message_id = options.delete(:message_id)
        get "accounts/#{account}/messages/#{message_id}/flags"
      elsif options.has_key?(:gmail_message_id) then
        gmail_message_id = options.delete(:gmail_message_id)
        if options[:gmail_message_id].start_with?('gm-') then
          get "accounts/#{account}/messages/#{gmail_message_id}/flags"
        else
          get "accounts/#{account}/messages/gm-#{gmail_message_id}/flags"
        end
      end
    end

    def get_message_body(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end

      account = options.delete(:account)
      if options.has_key?(:email_message_id) then
        email_message_id = options.delete(:email_message_id)
        get "accounts/#{account}/messages/#{email_message_id}/body"
      elsif options.has_key?(:message_id) then
        message_id = options.delete(:message_id)
        get "accounts/#{account}/messages/#{message_id}/body"
      elsif options.has_key?(:gmail_message_id) then
        gmail_message_id = options.delete(:gmail_message_id)
        if options[:gmail_message_id].start_with?('gm-') then
          get "accounts/#{account}/messages/#{gmail_message_id}/body"
        else
          get "accounts/#{account}/messages/gm-#{gmail_message_id}/body"
        end
      end
    end

    def get_message_thread(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end

      if options.has_key?(:email_message_id) then
        get "accounts/#{options[:account]}/messages/#{options[:email_message_id]}/thread"
      elsif options.has_key?(:message_id) then
        get "accounts/#{options[:account]}/messages/#{options[:message_id]}/thread"
      elsif options.has_key?(:gmail_message_id) then
        if options[:gmail_message_id].start_with?('gm-') then
          get "accounts/#{options[:account]}/messages/#{options[:gmail_message_id]}/thread"
        else
          get "accounts/#{options[:account]}/messages/gm-#{options[:gmail_message_id]}/thread"
        end
      end
    end

    def list_threads(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}/threads", options
    end

    def get_thread(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end

      if options.has_key?(:email_message_id) then
        get "accounts/#{options[:account]}/messages/#{options[:email_message_id]}/thread"
      elsif options.has_key?(:message_id) then
        get "accounts/#{options[:account]}/messages/#{options[:message_id]}/thread"
      elsif options.has_key?(:gmail_message_id) then
        if options[:gmail_message_id].start_with?('gm-') then
          get "accounts/#{options[:account]}/messages/#{options[:gmail_message_id]}/thread"
        else
          get "accounts/#{options[:account]}/messages/gm-#{options[:gmail_message_id]}/thread"
        end
      elsif options.has_key?(:gmail_thread_id) then
        if options[:gmail_thread_id].start_with?('gm-') then
          get "accounts/#{options[:account]}/threads/#{options[:gmail_thread_id]}"
        else
          get "accounts/#{options[:account]}/threads/gm-#{options[:gmail_thread_id]}"
        end
      end
    end

    def add_account(options)
      if ! options.has_key?(:email) then
        raise ArgumentError, "missing required argument email", caller
      end
      post "accounts", options
    end

    def modify_account(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      put "accounts/#{account}", options
    end

    def get_account(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      get "accounts/#{account}"
    end

    def list_account_email_addresses(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      get "accounts/#{options[:account]}/email_addresses"
    end

    def add_email_address_to_account(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:email_address) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      post "accounts/#{account}/email_addresses", options
    end

    def list_accounts(options)
      get "accounts", options
    end

    def modify_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      account = options.delete(:account)
      label = options.delete(:label)
      put "accounts/#{account}/sources/#{label}", options
    end

    def reset_source_status(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      put "accounts/#{options[:account]}/sources/#{options[:label]}", { :status => 1 }
    end

    def list_sources(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      get "accounts/#{options[:account]}/sources"
    end

    def get_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      get "accounts/#{options[:account]}/sources/#{options[:label]}"
    end

    def add_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:type) then
        options[:type] = 'imap'
      end
      account = options.delete(:account)
      post "accounts/#{account}/sources", options
    end

    def delete_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      delete "accounts/#{options[:account]}/sources/#{options[:label]}"
    end

    def sync_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        post "accounts/#{options[:account]}/sync"
      else
        post "accounts/#{options[:account]}/sources/#{options[:label]}"
      end
    end

    def get_sync(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        get "accounts/#{options[:account]}/sync"
      else
        get "accounts/#{options[:account]}/sources/#{options[:label]}"
      end
    end

    def add_folder_to_source(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      put "accounts/#{options[:account]}/sources/#{options[:label]}/folders/#{options[:folder]}"
    end

    def list_source_folders(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:label) then
        raise ArgumentError, "missing required argument label", caller
      end
      get "accounts/#{options[:account]}/sources/#{options[:label]}/folders"
    end

    def list_webhooks(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      get "accounts/#{options[:account]}/webhooks"
    end

    def get_webhook(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:webhook_id) then
        raise ArgumentError, "missing required argument webhook_id", caller
      end
      get "accounts/#{options[:account]}/sources/#{options[:webhook_id]}"
    end

    def add_webhook(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      account = options.delete(:account)
      post "accounts/#{account}/webhooks", options
    end

    def delete_webhook(options)
      if ! options.has_key?(:account) then
        raise ArgumentError, "missing required argument account", caller
      end
      if ! options.has_key?(:webhook_id) then
        raise ArgumentError, "missing required argument webhook_id", caller
      end
      delete "accounts/#{options[:account]}/sources/#{options[:webhook_id]}"
    end

    private

    def url(*args)
      if args.length == 1
        "/#{ContextIO::VERSION}/#{args[0]}"
      else
        "/#{ContextIO::VERSION}/#{args.shift.to_s}?#{parametrize args.last}"
      end
    end

    def get(*args)
      @token.get(url(*args), { 'Accept' => 'application/json' })
    end

    def delete(*args)
      @token.delete(url(*args), { 'Accept' => 'application/json' })
    end

    def put(action, args=nil)
      @token.put(url(action), args, { 'Accept' => 'application/json' })
    end

    def post(action, args=nil)
      @token.post(url(action), args, { 'Accept' => 'application/json' })
    end

    def parametrize(options)
      URI.escape(options.collect do |k,v|
        v = v.to_i if k == :since
        v = v.join(',') if v.instance_of?(Array)
        k = k.to_s.gsub('_', '')
        "#{k}=#{v}"
      end.join('&'))
    end
  end
end
