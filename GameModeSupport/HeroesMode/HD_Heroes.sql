-------------------------------------
--          Heros Adjustments      --
-------------------------------------
delete from TraitModifiers where TraitType = 'TRAIT_LEADER_GILGAMESH_HEROES';
update TraitModifiers set TraitType = 'TRAIT_LEADER_GILGAMESH_HEROES' where TraitType = 'TRAIT_LEADER_ADVENTURES_ENKIDU';