require 'digest'
require 'time'

class ProofOfWork
  attr_reader :challenge
  attr_reader :work_factor
  attr_reader :time_range

  # Time range is in seconds.
  def initialize(challenge:, work_factor:, time_range: 10)
    @challenge = challenge
    @work_factor = work_factor
    @time_range = time_range
  end

  def mint
    i = 0
    begin
      i += 1
      timestamp = Time.now
      token = make_token(i, timestamp)
    end while(!verify(token))

    { token: token, timestamp: timestamp }
  end

  def verify(token)
    return false if !time_from_token(token).between?(Time.now - time_range, Time.now)

    digest(token).start_with?("0" * work_factor)
  end

  def digest(token)
    Digest::SHA2.hexdigest(@challenge + token)
  end

  private

  def make_token(i, timestamp)
    i.to_s + "|" + timestamp.to_i.to_s
  end

  def time_from_token(token)
    Time.at(token.split("|").last.to_i)
  end
end
