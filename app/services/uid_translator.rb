# frozen_string_literal: true
class UidTranslator
  # Given an AIC-minted uid, translate it to an appropriately treeified uri for Fedora.
  # Example: TX-123456 becomes TX/12/34/56/TX-123456
  # If the provided id doesn't conform to AIC minting specs, then use ActiveFedora's default.
  # @param [String] id
  def self.id_to_uri(id)
    return original_uri(id) unless id =~ /^[A-Z]{2,2}/
    path = id.delete('-')
    (path.scan(/..?/).first(4) + [id]).join('/')
  end

  # Given an AIC-minted uid, translate it to a treeified uri for Fedora based
  # on an MD5 checksum of the UID. This allow to predictably map resource UIDs
  # to pseudo-opaque, balanced paths and deprecates id_to_uri for minting LAKE
  # resources.
  # Example: TX-123456 becomes b1/a7/9f/e97/b1a79fe97-76ca-d2ce-6260-d0fb5aebedd
  # If the provided id doesn't conform to AIC minting specs, then use
  # ActiveFedora's default.
  # @param [String] id
  def self.id_to_hash_uri(id)
    return original_uri(id) unless id =~ /^[A-Z]{2,2}/
    hash = Digest::MD5.hexdigest(id)
    # @TODO I know this is asinine.
    path = hash[0,8] + '-' + hash[8,4] + '-' + hash[12,4] + '-' + hash[16,4] + '-' + hash[20..-1]
    (path.scan(/..?/).first(4) + [id]).join('/')
  end

  def self.original_uri(id)
    ActiveFedora::Noid.treeify(id)
  end
end
