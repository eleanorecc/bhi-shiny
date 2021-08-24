
CREATE TABLE [IndexScores] (
  [region_id] INT,
  [dimension] TEXT,
  [goal] TEXT,
  [score] REAL,
  [year] INTEGER,
  PRIMARY KEY (region_id, dimension, goal, year)
) WITHOUT ROWID;

CREATE TABLE [Regions] (
  [region_id] INT PRIMARY KEY,
  [subbasin] TEXT,
  [eez] TEXT,
  [region_name] TEXT,
  [area_km2] REAL,
  [region_order] INTEGER,
  FOREIGN KEY (region_id) REFERENCES IndexScores (region_id)
) WITHOUT ROWID;

CREATE TABLE [Subbasins] (
  [helcom_id] NVARCHAR,
  [region_id] INT PRIMARY KEY,
  [subbasin] TEXT,
  [area_km2] REAL,
  [subbasin_order] INTEGER,
  FOREIGN KEY (region_id) REFERENCES IndexScores (region_id)
) WITHOUT ROWID;

CREATE UNIQUE INDEX idx_subbasin ON Subbasins (subbasin);

CREATE TABLE [Goals] (
  [goal] TEXT PRIMARY KEY,
  [goal_name] TEXT,
  [description] TEXT,
  FOREIGN KEY (goal) REFERENCES IndexScores (goal)
) WITHOUT ROWID;

CREATE TABLE [DataSources] (
  [goal] TEXT,
  [dataset] TEXT,
  [source] TEXT,
  [reflink] TEXT,
  PRIMARY KEY (goal, dataset),
  FOREIGN KEY (goal) REFERENCES Goals (goal)
);

CREATE TABLE [FlowerConf] (
  [goal] TEXT PRIMARY KEY,
  [parent] TEXT,
  [name_flower] TEXT,
  [petalweight] REAL,
  [order_hierarchy] REAL,
  FOREIGN KEY (goal) REFERENCES Goals (goal)
) WITHOUT ROWID;
