-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_digest VARCHAR(255) NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Children table
CREATE TABLE children (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    birth_date DATE,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Collections table (e.g., Junior Classics volumes)
CREATE TABLE collections (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Literary Works table
CREATE TABLE literary_works (
    id SERIAL PRIMARY KEY,
    collection_id INTEGER REFERENCES collections(id),
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    content_type VARCHAR(50) NOT NULL, -- 'book', 'short_story', 'poem', etc.
    page_number INTEGER,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Tags table
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Literary Works Tags (junction table)
CREATE TABLE literary_works_tags (
    literary_work_id INTEGER REFERENCES literary_works(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (literary_work_id, tag_id)
);

-- Programs table
CREATE TABLE programs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id), -- NULL for official programs
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_age_min INTEGER,
    target_age_max INTEGER,
    estimated_duration INTEGER, -- in days
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Program Items table (order of literary works in a program)
CREATE TABLE program_items (
    id SERIAL PRIMARY KEY,
    program_id INTEGER REFERENCES programs(id),
    literary_work_id INTEGER REFERENCES literary_works(id),
    order_in_program INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Reading Entries table
CREATE TABLE reading_entries (
    id SERIAL PRIMARY KEY,
    child_id INTEGER REFERENCES children(id),
    literary_work_id INTEGER REFERENCES literary_works(id),
    status VARCHAR(20) NOT NULL, -- 'not_started', 'in_progress', 'completed'
    start_date DATE,
    end_date DATE,
    personal_notes TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Reviews table
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    literary_work_id INTEGER REFERENCES literary_works(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Reading Lists table
CREATE TABLE reading_lists (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

-- Reading List Items table
CREATE TABLE reading_list_items (
    id SERIAL PRIMARY KEY,
    reading_list_id INTEGER REFERENCES reading_lists(id),
    literary_work_id INTEGER REFERENCES literary_works(id),
    order_in_list INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);


# app/models/tag.rb
class Tag < ApplicationRecord
  has_many :taggings
  has_many :collections, through: :taggings, source: :taggable, source_type: 'Collection'
  has_many :literary_works, through: :taggings, source: :taggable, source_type: 'LiteraryWork'
  has_many :programs, through: :taggings, source: :taggable, source_type: 'Program'
end

# app/models/tagging.rb
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
end

# app/models/collection.rb
class Collection < ApplicationRecord
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  # ... other associations
end

# app/models/literary_work.rb
class LiteraryWork < ApplicationRecord
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  # ... other associations
end

# app/models/program.rb
class Program < ApplicationRecord
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  # ... other associations
end

# db/migrate/YYYYMMDDHHMMSS_create_tags.rb
class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true
  end
end

# db/migrate/YYYYMMDDHHMMSS_create_taggings.rb
class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, polymorphic: true, null: false
      t.timestamps
    end
    add_index :taggings, [:taggable_type, :taggable_id, :tag_id], unique: true
  end
end