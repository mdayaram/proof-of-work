require 'digest'

class ProofOfWork
  attr_reader :challenge
  attr_reader :work_factor

  def initialize(challenge, work_factor)
    @challenge = challenge
    @work_factor = work_factor
  end

  def mint
    i = 0
    begin
      i += 1
      token = next_token(i)
    end while(!verify(token))
    token
  end

  def verify(token)
    digest(token).start_with?("0" * work_factor)
  end

  def digest(token)
    Digest::SHA2.hexdigest(@challenge + token)
  end

  private

  def next_token(i)
    i.to_s
  end
end
