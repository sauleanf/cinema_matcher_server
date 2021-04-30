# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_30_150847) do

  create_table "director_sets", force: :cascade do |t|
    t.integer "director_id"
    t.integer "picture_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["director_id", "picture_id"], name: "index_director_sets_on_director_id_and_picture_id", unique: true
  end

  create_table "directors", force: :cascade do |t|
    t.string "fullname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "feature_sets", force: :cascade do |t|
    t.string "parent_type"
    t.integer "parent_id"
    t.boolean "adult"
    t.boolean "action"
    t.boolean "adventure"
    t.boolean "animation"
    t.boolean "comedy"
    t.boolean "crime"
    t.boolean "documentary"
    t.boolean "drama"
    t.boolean "fantasy"
    t.boolean "horror"
    t.boolean "mystery"
    t.boolean "romance"
    t.boolean "scifi"
    t.boolean "short"
    t.boolean "sport"
    t.boolean "superhero"
    t.boolean "thriller"
    t.integer "year"
    t.integer "length"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "rating"
    t.index ["parent_type", "parent_id"], name: "index_feature_sets_on_parent"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "other_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "pending"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "first_user_id"
    t.integer "second_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "interested_users", force: :cascade do |t|
    t.integer "recommendation_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recommendation_id"], name: "index_interested_users_on_recommendation_id"
    t.index ["user_id"], name: "index_interested_users_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "image"
    t.datetime "released_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recommendation_statuses", force: :cascade do |t|
    t.integer "recommendation_id"
    t.integer "user_id"
    t.boolean "confirmed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recommendation_id"], name: "index_recommendation_statuses_on_recommendation_id"
    t.index ["user_id"], name: "index_recommendation_statuses_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "picture_id"
    t.integer "room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "room_users", force: :cascade do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_room_users_on_room_id"
    t.index ["user_id"], name: "index_room_users_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "fullname"
    t.string "profile_image"
    t.string "username"
    t.string "hashed_password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
