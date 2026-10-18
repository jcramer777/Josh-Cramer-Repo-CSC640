-- Seed data used by the acceptance tests (ids are fixed on purpose).
-- Seed user: seed@example.com / password123
INSERT IGNORE INTO users (id, name, email, password_hash) VALUES
  (1, 'Seed User', 'seed@example.com', '$2y$10$GQ21WSfOTLHilYy0tnOJiugifGcLRrFJemdb2xQRWJM.967CgrbAi');

INSERT IGNORE INTO categories (id, name) VALUES
  (1, 'Work'),
  (2, 'Personal'),
  (3, 'School');

INSERT IGNORE INTO tasks (id, title, done, category_id, user_id) VALUES
  (1, 'Finish HW4 plan', 0, 3, 1),
  (2, 'Buy groceries', 1, 2, 1);
