-------------------------------------
--  Temporary update database sql  --
-------------------------------------

update Units set Combat = Combat - 3 where Combat > 45 and PromotionClass = 'PROMOTION_CLASS_HEAVY_CAVALRY';

----------------------------------------------------- 删除【土木工程】市政 ------------------------------------------------------

	-- 原【土木工程】市政解锁内容搬运到新【土木工程】科技上
update Policies set PrereqTech = 'TECH_CIVIL_ENGINEERING_HD', PrereqCivic = NULL where PrereqCivic = 'CIVIC_CIVIL_ENGINEERING';
update Buildings set PrereqTech = 'TECH_CIVIL_ENGINEERING_HD', PrereqCivic = NULL where PrereqCivic = 'CIVIC_CIVIL_ENGINEERING';
update Districts set PrereqTech = 'TECH_CIVIL_ENGINEERING_HD', PrereqCivic = NULL where PrereqCivic = 'CIVIC_CIVIL_ENGINEERING';
	-- 被动效果：丘陵农场
update Improvement_ValidTerrains set PrereqCivic = NULL, PrereqTech = 'TECH_CIVIL_ENGINEERING_HD' where PrereqCivic = 'CIVIC_CIVIL_ENGINEERING';
	-- 被动效果：伐木场、圩田、甘榜屋
update Improvement_BonusYieldChanges set PrereqCivic = NULL, PrereqTech = 'TECH_CIVIL_ENGINEERING_HD' where PrereqCivic = 'CIVIC_CIVIL_ENGINEERING';
	-- 相关modifier (包括但不限于加拿大冻土丘陵农场)
update Requirements set RequirementType = 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY' where RequirementId = 'REQUIRES_PLAYER_HAS_CIVIL_ENGINEERING_CIVIC';
update RequirementArguments set Name = 'TechnologyType', Value = 'TECH_CIVIL_ENGINEERING_HD' where RequirementId = 'REQUIRES_PLAYER_HAS_CIVIL_ENGINEERING_CIVIC';

delete from AiFavoredItems where Item = 'CIVIC_CIVIL_ENGINEERING';
delete from Civics where CivicType = 'CIVIC_CIVIL_ENGINEERING';

-----------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------------