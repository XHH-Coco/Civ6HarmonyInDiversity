--||====================base functions====================||--
Utils = ExposedMembers.DLHD.Utils;
GameEvents = ExposedMembers.GameEvents;
--按钮是否可用
function AmericaButtonDisable(pCity)
    -- 为了实现更好的tooltip，我们需要一个表储存变量
    local detail = {
        disable    = true,      -- 按钮是否可用
        hasView    = false,     -- 是否可以预览花费的金币
        foodhas    = 0,          -- 已经拥有的食物
        foodneed   = 0,         -- 人口增长需要的食物
        goldneed   = 0,         -- 人口增长需要的金币
        reason     = 'NONE'     -- 不可用的原因
    }
    -- 获取城市对象
    if pCity then
        --食物
        local foodhas = pCity:GetGrowth():GetFood();
        --人口增长需要的食物总量
        local growthThreshold = pCity:GetGrowth():GetGrowthThreshold();
        --人口增长的食物
        local foodneed = math.ceil(growthThreshold);
        foodneed = foodneed < 0 and 0 or foodneed;
        --人口增长需要的金币
        local goldneed    = foodneed * 4;
        local pPlayer     = Players[pCity:GetOwner()]
        --玩家所拥有的金币
        local playerGold  = pPlayer and pPlayer:GetTreasury():GetGoldBalance() or 0;

        detail.disable    = playerGold < goldneed;   -- 玩家金币不足的话，就是不可用
        detail.hasView    = true;                    -- 但是我们可以预览花费的金币
        detail.foodhas    = foodhas;                 -- 记录食物
        detail.foodneed   = foodneed;                -- 记录需要的食物
        detail.goldneed   = goldneed;               -- 记录需要的金币
        detail.reason     = Locale.Lookup('LOC_AMERICA_NO_GOLD_WARNING')  -- 如果不可用的话，方便给tooltip加上不可用的原因

    else
        -- 城市对象不存在（基本上不会遇到），不可用
        detail.reason = Locale.Lookup('LOC_AMERICA_NO_CITY_WARNING')
    end
    -- 返回detail
    return detail
end

-- 用于刷新按钮的函数
function AmericaButtonReset()
    -- 获取城市对象，玩家当前UI选中的城市
    local pCity = UI.GetHeadSelectedCity()
    -- 城市对象存在吗？
    if pCity then
        -- 获取城市所有者（玩家）的对象
        local pPlayer = Players[pCity:GetOwner()]
        -- 判断property，确认玩家是否拥有美国UA
        if pPlayer:GetProperty('AmericaProperty') ~= nil then
            -- 有，显示按钮
            Controls.America_HD_City_Stack:SetHide(false)
            -- 获取我们需要的信息
            local detail = AmericaButtonDisable(pCity)
            -- 按钮可不可用？
            local disabled = detail.disable
            -- 设置按钮可用，SetDisabled(true)的话鼠标放上去什么也不会发生，点也点不了
            Controls.America_HD_City_Button:SetDisabled(disabled)
            -- 三元运算符，如果不可用的话将透明度设置为0.4，可用的话为1
            -- 方便直观看出按钮可用不可用（透明度为0.4的话，按钮会变暗，程度跟f社的一样）
            Controls.America_HD_City_Button:SetAlpha((disabled and 0.4) or 1)
            -- 设置tooltip
            -- 最基本的
            local tooltip = Locale.Lookup('LOC_TRAIT_CIVILIZATION_FOUNDING_FATHERS_NAME') ..
                '[NEWLINE][NEWLINE]' .. Locale.Lookup('LOC_AMERECA_BUTTON_DESCRIPTION')

            -- 有预览的话加上
            if detail.hasView then
                tooltip = tooltip .. '[NEWLINE][NEWLINE]' ..
                    Locale.Lookup('LOC_AMERECA_BUTTON_DETAIL', detail.goldneed)
            end

            -- 不可用的话，加上原因
            if detail.disable then
                tooltip = tooltip .. '[NEWLINE][NEWLINE]' .. detail.reason
            end

            -- 给按钮设置tooltip
            Controls.America_HD_City_Button:SetToolTipString(tooltip)
        else
            -- 没有，隐藏
            Controls.America_HD_City_Stack:SetHide(true)
        end
    else
        -- 不存在，隐藏
        Controls.America_HD_City_Stack:SetHide(true)
    end
end

-- 按钮点击后的函数
function AmericaButtonClick()
    -- 获取玩家当前UI选中的城市对象
    local pCity = UI.GetHeadSelectedCity()
    if pCity then
        -- 获取我们需要的信息（城市id，推进所需生产力，信仰值花费，点击按钮时城市正在进行的建造）
        local detail = AmericaButtonDisable(pCity)
        -- 不可用的话，直接返回（似乎有点多余）
        if detail.disable then return end
        -- UI请求玩家操作，联机跨环境保证数据同步的官方方法
        -- 不是玩家的回合不会起任何效果
        -- OnStart的值就是请求执行的函数（可以这么理解，但这个实际上是一个事件名，我们把要执行的函数注册进去了）
        UI.RequestPlayerOperation(Game.GetLocalPlayer(),
            PlayerOperations.EXECUTE_SCRIPT, {
                cityID     = pCity:GetID(),
                foodhas    = detail.foodhas,
                foodneed   = detail.foodneed,
                goldneed   = detail.goldneed,
                OnStart    = 'AmericaAddPop'
            }); UI.PlaySound('Purchase_With_Gold') -- 播放声音，这里为使用信仰值购买时的音效。如果你愿意也可以“一破，卧龙出山！”
    end
end

--||===================Events functions===================||--

-- 城市选中时
function AmericaCitySelectChange(owner, cityID, i, j, k, isSelected)
    -- 获得本地玩家
    local loaclPlayerID = Game.GetLocalPlayer()
    -- 本地玩家是否与触发该事件的玩家一致，是否选中城市
    if owner == loaclPlayerID and isSelected then
        -- 是，且选中城市
        -- 刷新按钮
        AmericaButtonReset()
    end
    -- 这个函数似乎有点多余
end

--添加按钮到城市面板
function AmericaOnLoadGameViewStateDone()
    -- 不讲了，具体看Hemmelfort的教程
    local pContext = ContextPtr:LookUpControl("/InGame/CityPanel/ActionStack")
    if pContext then
        Controls.America_HD_City_Stack:ChangeParent(pContext)
        Controls.America_HD_City_Button:RegisterCallback(Mouse.eLClick, AmericaButtonClick)
        Controls.America_HD_City_Button:RegisterCallback(Mouse.eMouseEnter, function()
            UI.PlaySound("Main_Menu_Mouse_Over")
        end) -- 鼠标进入按钮时，播放与鼠标进入f社的按钮时相同的音效
        -- 刷新按钮
        AmericaButtonReset()
    end
end

--||======================initialize======================||--

function Initialize()
    -------------------Events-------------------
    -- 具体看Hemmelfort的教程
    Events.LoadGameViewStateDone.Add(AmericaOnLoadGameViewStateDone)
    -- 城市选中刷新一遍
    Events.CitySelectionChanged.Add(AmericaCitySelectChange)
    -------------------Resets-------------------
    -- 本地玩家换了后刷新一遍
    -- 感觉只有看海时可能会换玩家
    Events.LocalPlayerChanged.Add(AmericaButtonReset)

    -- 刷新按钮的时机
    Events.CityAddedToMap.Add(AmericaButtonReset)
    Events.CityProductionQueueChanged.Add(AmericaButtonReset)
    Events.CityProductionUpdated.Add(AmericaButtonReset)
    Events.CityProductionChanged.Add(AmericaButtonReset)
    Events.CityProductionCompleted.Add(AmericaButtonReset)
    Events.CityPopulationChanged.Add(AmericaButtonReset)

    ---------------ExposedMembers---------------

    --------------------------------------------
    print('Initial success!')
end

Initialize()
