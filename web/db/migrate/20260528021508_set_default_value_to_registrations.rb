class SetDefaultValueToRegistrations < ActiveRecord::Migration[8.1]
  def change
    change_column_default :registrations, :status, from: nil, to: "unregistered"
  end
end
