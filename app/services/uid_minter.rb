# frozen_string_literal: true
class UidMinter
  attr_reader :prefix

  # @param [String] prefix two-letter prefix indicating the type of resource
  def initialize(prefix)
    raise(ArgumentError, "Can't mint a UID without a prefix") unless prefix.present?
    @prefix = prefix
  end

  # Returns a unique identifier with a two-letter prefix and six digits
  # @return [String] such as "TX-123456"
  def mint
    return mock_id unless Rails.env.production?
    uid_from_database
  end

  # Returns the MD5 checksum of a UID, formatted as a pseudo-random UUID as per
  # RFC 4122.
  # @param [String] id
  # @return [String] Hash (with dashes added) of original UID
  def hash(id)
    hash = Digest::MD5.hexdigest(id)
    [hash[0..7], hash[8..11], hash[12..15], hash[16..19], hash[20..-1]].join('-')
  end

  def uid_from_database
    response = new_uid
    response.rows.map(&:first).first
  end

  private

    # Because the process of creating a new uid is tied to a database stored procedure that only exists
    # on specific servers, a mock method is provided for testing and development purposes.
    def mock_id
      [prefix, rand.to_s[2..7]].join("-")
    end

    # Calls the stored procedure defined in the Uid model to create a new uid.
    # @return [ActiveRecord::Result]
    def new_uid
      Uid.mint_uid(prefix)
    end
end
