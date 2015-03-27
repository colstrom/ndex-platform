require_relative 'content/json'
require_relative 'content/validation'
require_relative 'data/redis'
require_relative 'type/collection'

class IndexResource < CollectionResource
  include JSONSupport
  include RedisSupport
  include ValidationSupport

  def create_path
    "tasks/#{ id }"
  end

  private

  def id
    @id ||= redis.incr('ndex:tasks:index').to_i
  end

  def input
    redis.rpush 'ndex:tasks:pending', id
    payload.each do |key, value|
      redis.hset "ndex:task:#{id}", key, value
    end
  end

  def validation_schema
    {
      'type' => 'object',
      'required' => ['url'],
      'properties' => {
        'url' => { 'type' => 'string' }
      }
    }
  end

  def output
    { 'pending' => redis.llen('ndex:tasks:pending') }
  end
end
