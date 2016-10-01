# frozen_string_literal: true
# Allows us to access the database responsible for minting uids. Although we never query the table directly,
# we define an AR::Base instance that corresponds to an existing table and call the stored procedure from there.
class Uid < ActiveRecord::Base
  establish_connection :uidminter

  def self.table_name
    "tbl_uids"
  end

  # Calls a stored procedure to mint a UID with a given prefix.
  # @param [String] prefix is the two-letter prefix for an asset type
  # @return [ActiveRecord::Result]
  #
  # Sample result:
  #   <ActiveRecord::Result:0x007f66cb551890 @columns=["newid"],
  #     @rows=[["TX-000003"]],
  #     @hash_rows=nil,
  #     @column_types={"newid"=>#<ActiveRecord::Type::String:0x007f66cb572b08 @precision=nil, @scale=nil, @limit=nil>}>
  def self.mint_uid(prefix)
    connection.exec_query("select mintUid('#{prefix}', '') AS newid")
  end
end
