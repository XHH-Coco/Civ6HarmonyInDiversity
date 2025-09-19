------------------- 资源分类 -------------------
create table if not exists HD_ResourceClassificationTypes(
  ResourceClassificationType  TEXT    not NULL,
  Name                        TEXT,
PRIMARY KEY('ResourceClassificationType'));

create table if not exists HD_Resource_Classification(
  ResourceType                TEXT    not NULL,
  ResourceClassificationType  TEXT    not NULL,
PRIMARY KEY('ResourceType', 'ResourceClassificationType'));