CREATE TABLE wines (
  id INTEGER NOT NULL PRIMARY KEY,
  cluster_id SMALLINT,
  name VARCHAR(50),
  content MEDIUMBLOB,
  rating SMALLINT 
)
