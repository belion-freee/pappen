class AddEventsPrimaryKey < ActiveRecord::Migration[5.1]
  def up
    add_column :events, :eid, :string

    reversible do |r|
      r.up {
        execute "UPDATE events SET eid = id"

        # null制約はpudateした後でつけないとエラーになる
        change_column_null :events, :eid, false, 0

        # 外部キーの再生成
        remove_foreign_key :room_member_events, column: :event_id

        change_column :room_member_events, :event_id, :string
        change_column :expenses, :event_id, :string

        execute "ALTER TABLE events DROP CONSTRAINT events_pkey;"
        execute "ALTER TABLE events ADD CONSTRAINT events_pkey PRIMARY KEY(eid);"
      }

      add_foreign_key :room_member_events, :events, column: :event_id, primary_key: :eid
      add_foreign_key :expenses, :events, column: :event_id, primary_key: :eid
    end
  end

  def down
    reversible do |r|
      r.up {
        execute "ALTER TABLE events DROP CONSTRAINT events_pkey;"
        execute "ALTER TABLE events ADD CONSTRAINT events_pkey PRIMARY KEY(id);"
      }
    end

    # 外部キーの再生成
    remove_foreign_key :room_member_events, column: :event_id
    add_foreign_key :room_member_events, :events, column: :event_id, primary_key: :id

    # 外部キーの再生成
    remove_foreign_key :expenses, column: :event_id
    add_foreign_key :expenses, :events, column: :event_id, primary_key: :id

    remove_column :events, :eid
  end
end
