insert or ignore into Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
('MODIFIER_RELIC_CREATOR', 'MODIFIER_PLAYER_GRANT_RELIC', 1, 1);

insert or ignore into ModifierArguments (ModifierId, Name, Value) VALUES
('MODIFIER_RELIC_CREATOR', 'Amount', '1');