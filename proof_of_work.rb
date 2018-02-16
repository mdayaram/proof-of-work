require 'digest'
require 'time'
require 'set'

class ProofOfWork
  attr_reader :challenge
  attr_reader :work_factor
  attr_reader :time_range
  attr_reader :verified_token_cache

  # Time range is in seconds.
  def initialize(challenge:, work_factor: 4, time_range: 10)
    @challenge = challenge
    @work_factor = work_factor
    @time_range = time_range
    @verified_token_cache = Set.new
  end

  def mint
    i = 0
    begin
      i += 1
      timestamp = Time.now
      token = make_token(i, timestamp)
    end while(!is_valid?(token))

    token
  end

  def verify(token)
    return false if verified_token_cache.include?(token)
    return false if !time_from_token(token).between?(Time.now - time_range, Time.now)

    result = is_valid?(token)
    verified_token_cache << token if result

    result
  end

  def digest(token)
    Digest::SHA2.hexdigest(@challenge + token)
  end

  private

  def is_valid?(token)
    digest(token).start_with?("0" * work_factor)
  end

  def make_token(i, timestamp)
    i.to_s + "|" + timestamp.to_i.to_s
  end

  def time_from_token(token)
    Time.at(token.split("|").last.to_i)
  end
end
