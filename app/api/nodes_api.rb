require 'json'
require 'pds/model/node'
require 'pds/helpers/data_helpers'


App.post('/v1/nodes') do
  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  payload = PDS::Helpers::DataHelpers.convert_to_json!(body_params, request)
  # GH: Content translations here
  new_nodes = with_defaults(payload['resources'], PDS::Model::Node)

  begin
    timestamp!(new_nodes)
    nodes_created = data_adapter.create(:nodes, resources: new_nodes)

    status 201
    nodes_created.to_json
    payload = PDS::Helpers::DataHelpers.convert_to_content_type!(body_params, request)

  rescue PDS::DataAdapter::Conflict => e
    render_error(400, 'Bad Request. Unable to create requested nodes, check for duplicate nodes', e.message)
  end
end


App.delete('/v1/nodes/{name}') do
  # TODO: validate input
  deleted = data_adapter.delete(:nodes, filters: [['=', 'name', params['name']]])
  if deleted.zero?
    render_error(404, 'Node not found')
  else
    status 204
  end
end


App.get('/v1/nodes') do
  nodes = data_adapter.read(:nodes)
  nodes.to_json
end


App.get('/v1/nodes/{name}') do
  # TODO: validate input
  nodes = data_adapter.read(:nodes, filters: [['=', 'name', params['name']]])
  if nodes.empty?
    render_error(404, 'Node not found')
  else
    nodes.first.to_json
  end
end


App.put('/v1/nodes/{name}') do
  # TODO: validate input
  body_params = request.body.read
  return render_error(400, 'Bad Request. Body params are required') if body_params.empty?

  body = JSON.parse(body_params)

  node = with_defaults(body, PDS::Model::Node)
  node['name'] = params['name']

  update_timestamps!(:nodes, [node])
  data_adapter.upsert(:nodes, resources: [node])

  if node['created-at'] == node['updated-at']
    status 201
  else
    status 200
  end

  node.to_json
end
