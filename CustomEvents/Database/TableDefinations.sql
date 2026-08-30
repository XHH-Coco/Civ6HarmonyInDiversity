create table if not exists HD_CustomEvent_UIStyle(
  UIStyle             TEXT not NULL,
  LuaEventName        TEXT not NULL,
  MaxSelectionAmount  INT not NULL Default 3,
  PRIMARY KEY('UIStyle')
);

insert or ignore into HD_CustomEvent_UIStyle (UIStyle, LuaEventName, MaxSelectionAmount) values
  ('Light', 'HD_TriggerCustomEventPanel_Light', 6),
  ('Dark',  'HD_TriggerCustomEventPanel_Dark',  6);

create table if not exists HD_CustomEvents(
  CustomEventType   TEXT not NULL,
  Name              TEXT not NULL,
  Description       TEXT not NULL,
  Texture           TEXT default NULL,
  UIStyle           TEXT not NULL,
  Sound             TEXT default NULL,
  PRIMARY KEY('CustomEventType'),
  FOREIGN KEY('UIStyle') REFERENCES HD_CustomEvent_UIStyle('UIStyle') ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists HD_CustomEventSelections(
  SelectionType     TEXT not NULL,
  CustomEventType   TEXT not NULL,
  Icon              TEXT default NULL,
  Description       TEXT not NULL,
  ButtonText        TEXT not NULL,
  ButtonToolTip     TEXT default NULL,
  Sound             TEXT default NULL,
  PRIMARY KEY('SelectionType'),
  FOREIGN KEY('CustomEventType') REFERENCES HD_CustomEvents('CustomEventType') ON DELETE CASCADE ON UPDATE CASCADE
);

create table if not exists HD_CustomEventSelectionModifiers(
  SelectionType     TEXT not NULL,
  ModifierId        TEXT not NULL,
  PRIMARY KEY('SelectionType', 'ModifierId'),
  FOREIGN KEY('SelectionType') REFERENCES HD_CustomEventSelections('SelectionType') ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY('ModifierId') REFERENCES Modifiers('ModifierId') ON DELETE CASCADE ON UPDATE CASCADE
);