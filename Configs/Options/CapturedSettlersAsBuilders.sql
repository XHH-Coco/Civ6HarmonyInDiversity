-- update UnitCaptures set BecomesUnitType = 'UNIT_BUILDER' where CapturedUnitType = 'UNIT_SETTLER';

-- change era minimum turns
update Eras_XP1 set GameEraMinimumTurns = 40, GameEraMaximumTurns = 54 where EraType = 'ERA_ANCIENT';
update Eras_XP1 set GameEraMinimumTurns = 40, GameEraMaximumTurns = 60 where EraType not in ('ERA_ANCIENT', 'ERA_FUTURE');
