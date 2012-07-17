class CreateCargoManifests < ActiveRecord::Migration
  def change
    create_table :cargo_manifests do |t|
      t.date :created_at
      t.integer :manifest_num
      t.integer :origin_city_id
      t.integer :destiny_city_id
      t.integer :employee_id
      t.integer :total_guides
      t.integer :total_products
      t.decimal :total_weight

    end
    #fk a employee
    add_foreign_key :cargo_manifests, :employees

     #el fk destiny_city_id se une con cities
    constraint_name = "fk_cargo_manifests_destiny_city_id"

    execute "alter table cargo_manifests
              add constraint #{constraint_name}
              foreign key (destiny_city_id)
              references cities(id)"

     #el fk origin_city_id se une con cities
    constraint_name2 = "fk_cargo_manifests_origin_city_id"

    execute "alter table cargo_manifests
              add constraint #{constraint_name2}
              foreign key (origin_city_id)
              references cities(id)"
  end
end
