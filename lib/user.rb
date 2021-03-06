require 'pg'
require 'bcrypt'

class User
  def self.create(name:, username:, email:, password:)
    password = BCrypt::Password.create(password)
    columns = "(name, username, email, password)"
    values = "('#{name}','#{username}','#{email}','#{password}')"
    sql = "INSERT INTO users #{columns} VALUES #{values} RETURNING *;"
    result = DatabaseConnection.execute(sql).first

    User.new(
      id: result['id'].to_i,
      name: result['name'],
      username: result['username'],
      email: result['email']
    )
  end

  def self.find(id)
    return nil if id.nil?
    sql = "SELECT * FROM users WHERE id = #{id};"
    result = DatabaseConnection.execute(sql).first

    User.new(
      id: result['id'].to_i,
      name: result['name'],
      username: result['username'],
      email: result['email']
    )
  end

  def self.authenticate(email:, password:)
    sql = "SELECT * FROM users WHERE email = '#{email}'"
    result = DatabaseConnection.execute(sql)
    return false if result.ntuples == 0
    result = result.first
    password_hash = BCrypt::Password.new(result['password'])
    return false unless password_hash == password

    User.new(
      id: result['id'].to_i,
      name: result['name'],
      username: result['username'],
      email: result['email']
    )
  end

  attr_reader :id, :name, :username, :email

  def initialize(id:, name:, username:, email:)
    @id = id
    @name = name
    @username = username
    @email = email
  end
end
