module ThreeScale
    module API
      class Client
        attr_reader :http_client
  
        # @param [ThreeScale::API::HttpClient] http_client
  
        def initialize(http_client)
          @http_client = http_client
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] id Service ID
        def show_service(id)
          response = http_client.get("/admin/api/services/#{id}")
          extract(entity: 'service', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        def list_services
          response = http_client.get('/admin/api/services')
          extract(collection: 'services', entity: 'service', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list_applications(service_id: nil)
          params = service_id ? { service_id: service_id } : nil
          response = http_client.get('/admin/api/applications', params: params)
          extract(collection: 'applications', entity: 'application', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] id Application ID
        def show_application(id)
          find_application(id: id)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] id Application ID
        # @param [String] user_key Application User Key
        # @param [String] application_id Application App ID
        def find_application(id: nil, user_key: nil, application_id: nil)
          params = { application_id: id, user_key: user_key, app_id: application_id }.reject { |_, value| value.nil? }
          response = http_client.get('/admin/api/applications/find', params: params)
          extract(entity: 'application', from: response)
        end
  
        # @api public
        # @return [Hash] an Application
        # @param [Fixnum] plan_id Application Plan ID
        # @param [Hash] attributes Application Attributes
        # @option attributes [String] :name Application Name
        # @option attributes [String] :description Application Description
        # @option attributes [String] :user_key Application User Key
        # @option attributes [String] :application_id Application App ID
        # @option attributes [String] :application_key Application App Key(s)
        def create_application(account_id, attributes = {}, plan_id:, **rest)
          body = { plan_id: plan_id }.merge(attributes).merge(rest)
          response = http_client.post("/admin/api/accounts/#{account_id}/applications", body: body)
          extract(entity: 'application', from: response)
        end
  
        # @api public
        # @return [Hash] a Plan
        # @param [Fixnum] account_id Account ID
        # @param [Fixnum] application_id Application ID
        def customize_application_plan(account_id, application_id)
          response = http_client.put("/admin/api/accounts/#{account_id}/applications/#{application_id}/customize_plan")
          extract(entity: 'application_plan', from: response)
        end
  
        # @api public
        # @return [Hash] an Account
        # @param [String] name Account Name
        # @param [String] username User Username
        # @param [Hash] attributes User and Account Attributes
        # @option attributes [String] :email User Email
        # @option attributes [String] :password User Password
        # @option attributes [String] :account_plan_id Account Plan ID
        # @option attributes [String] :service_plan_id Service Plan ID
        # @option attributes [String] :application_plan_id Application Plan ID
        def signup(attributes = {}, name:, username:, **rest)
          body = { org_name: name,
                   username: username }.merge(attributes).merge(rest)
          response = http_client.post('/admin/api/signup', body: body)
          extract(entity: 'account', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Hash] attributes Service Attributes
        # @option attributes [String] :name Service Name
        def create_service(attributes)
          response = http_client.post('/admin/api/services', body: { service: attributes })
          extract(entity: 'service', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Hash] attributes Service Attributes
        # @option attributes [String] :name Service Name
        def update_service(service_id, attributes)
          response = http_client.put("/admin/api/services/#{service_id}", body: { service: attributes })
          extract(entity: 'service', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        def show_proxy(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/proxy")
          extract(entity: 'proxy', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        def update_proxy(service_id, attributes)
          response = http_client.patch("/admin/api/services/#{service_id}/proxy",
                                       body: { proxy: attributes })
          extract(entity: 'proxy', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list_mapping_rules(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules")
          extract(entity: 'mapping_rule', collection: 'mapping_rules', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Mapping Rule ID
        def show_mapping_rule(service_id, id)
          response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}")
          extract(entity: 'mapping_rule', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Hash] attributes Mapping Rule Attributes
        # @option attributes [String] :http_method HTTP Method
        # @option attributes [String] :pattern Pattern
        # @option attributes [Fixnum] :delta Increase the metric by delta.
        # @option attributes [Fixnum] :metric_id Metric ID
        def create_mapping_rule(service_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/proxy/mapping_rules",
                                      body: { mapping_rule: attributes })
          extract(entity: 'mapping_rule', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Mapping Rule ID
        def delete_mapping_rule(service_id, id)
          http_client.delete("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}")
          true
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] id Mapping Rule ID
        # @param [Hash] attributes Mapping Rule Attributes
        # @option attributes [String] :http_method HTTP Method
        # @option attributes [String] :pattern Pattern
        # @option attributes [Fixnum] :delta Increase the metric by delta.
        # @option attributes [Fixnum] :metric_id Metric ID
        def update_mapping_rule(service_id, id, attributes)
          response = http_client.patch("/admin/api/services/#{service_id}/mapping_rules/#{id}",
                                       body: { mapping_rule: attributes })
          extract(entity: 'mapping_rule', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list_metrics(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/metrics")
          extract(collection: 'metrics', entity: 'metric', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Metric Name
        def create_metric(service_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/metrics", body: { metric: attributes })
          extract(entity: 'metric', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] metric_id Metric ID
        def list_methods(service_id, metric_id)
          response = http_client.get("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods")
          extract(collection: 'methods', entity: 'method', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Fixnum] metric_id Metric ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Method Name
        def create_method(service_id, metric_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods",
                                      body: { metric: attributes })
          extract(entity: 'method', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] service_id Service ID
        def list_service_application_plans(service_id)
          response = http_client.get("/admin/api/services/#{service_id}/application_plans")
  
          extract(collection: 'plans', entity: 'application_plan', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] service_id Service ID
        # @param [Hash] attributes Metric Attributes
        # @option attributes [String] :name Application Plan Name
        def create_application_plan(service_id, attributes)
          response = http_client.post("/admin/api/services/#{service_id}/application_plans",
                                      body: { application_plan: attributes })
          extract(entity: 'application_plan', from: response)
        end
  
        # @api public
        # @return [Array<Hash>]
        # @param [Fixnum] application_plan_id Application Plan ID
        def list_application_plan_limits(application_plan_id)
          response = http_client.get("/admin/api/application_plans/#{application_plan_id}/limits")
  
          extract(collection: 'limits', entity: 'limit', from: response)
        end
  
        # @api public
        # @return [Hash]
        # @param [Fixnum] application_plan_id Application Plan ID
        # @param [Hash] attributes Metric Attributes
        # @param [Fixnum] metric_id Metric ID
        # @option attributes [String] :period Usage Limit period
        # @option attributes [String] :value Usage Limit value
        def create_application_plan_limit(application_plan_id, metric_id, attributes)
          response = http_client.post("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits",
                                      body: { usage_limit: attributes })
          extract(entity: 'limit', from: response)
        end
  
        # @param [Fixnum] application_plan_id Application Plan ID
        # @param [Fixnum] metric_id Metric ID
        # @param [Fixnum] limit_id Usage Limit ID
        def delete_application_plan_limit(application_plan_id, metric_id, limit_id)
          http_client.delete("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits/#{limit_id}")
          true
        end
  
        protected
  
        def extract(collection: nil, entity:, from:)
          from = from.fetch(collection) if collection
  
          case from
          when Array then from.map { |e| e.fetch(entity) }
          when Hash then from.fetch(entity) { from }
          when nil then nil # raise exception?
          else
            raise "unknown #{from}"
          end
        end
      end
    end
  end
  